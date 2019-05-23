# Uhura

# Things to be aware of

## Envied

The envied gem ensures that the environment variables you specify in Envfile exist.

If they don't you'll get initialization errors like the following:

```
[lex@k2 uhura]$ unset SOURCE_CLI_ID
[lex@k2 uhura]$ irb
Loading Rails...Error : 'load /home/lex/.irbrc' : uninitialized constant Source
irb: warn: can't alias context from irb_context.
2.6.1 :001 >
```

Export the missing environment variable:

```
[lex@k2 uhura]$ export SOURCE_CLI_ID=4
[lex@k2 uhura]$ irb
Loading Rails...SUCCESS!  Loaded ENV['IRB_LOGGER']: development, ENV['IRB_LOGGER']:
ActiveRecord::Base.connection.instance_values['config'][:adapter]: postgresql
@db = ActiveRecord::Base.connection
Example:  @db.tables
Loaded logger (standard_logger).  <= Can set using ENV['IRB_LOGGER'] values: standard | loud | quiet
irb: warn: can't alias context from irb_context.
uhura> AppCfg['SOURCE_CLI_ID']
4
uhura>
```

## auth_token gets reset when you rake db:drop

If you happen to do that and get a message like the following, the use the new auth_token value (or replace it with the old one you saved)

### Request
```
POST /api/v1/messages HTTP/1.1
Content-Type: application/json
Authorization: Bearer: eebdd83200c6ab4df957
Host: localhost:3000
Accept: */*
Cache-Control: no-cache

{
    "receiver_email": "alice@aol.com",
    "team_name": "Corporate Finance Team",
    "template_name": "Simple Template",
    "email_subject": "Picnic this Saturday",
    "email_message": "{:headers=>{:key1=>\"val1\", :key2=>\"val2\"}, :sections=>{:name=>\"val1\", :body=>\"val2\"}}",
    "sms_message": "Bring Drinks to the Picnic this Saturday"
}
```

### Response
```
{"error":"This Api Key does not exist."}
```

### auth_token value in ApiKey table
```
uhura> ApiKey.all
+----+--------------------------+------------+-------------------------+-------------------------+
| id | auth_token               | manager_id | created_at              | updated_at              |
+----+--------------------------+------------+-------------------------+-------------------------+
| 1  | r42z2dFig7Yqi5DVbUUKuDP6 | 1          | 2019-05-04 17:39:36 UTC | 2019-05-04 17:39:36 UTC |
| 2  | j5usM2ht5sy1GVukyZPBcqG5 | 2          | 2019-05-04 17:39:36 UTC | 2019-05-04 17:39:36 UTC |
+----+--------------------------+------------+-------------------------+-------------------------+
```

# Ruby Style Guide

https://github.com/rubocop-hq/ruby-style-guide#no-explicit-return


# Authentication

To maintain consistency with Exchequer-Server, Uhura implements auth security as follows:

* The message sender is a Manager, which is really an Application (App).
* The Manager identifies itself with a public_token (that's stored in the manager table)
* An auth_token is created when a Manager is created (it's stored in the api_keys table)
* When an application makes a send_message request, it passes the auth_token in the Authorization HTTP header
* The application also sends its public_token in the POST body.
* Uhura looks up the application in the Manager table and verifies the auth_token in the api_keys table.


# Sendgrid
Create an account at https://app.sendgrid.com/
* Get API key
* View sent email statistics.


Create Support Ticket to Activiate Account

https://stackoverflow.com/questions/42214048/sendgrid-returns-202-but-doesnt-send-email


# Add receiver account for testing
In Rails console:

```
lex = Receiver.create!(
	receiver: '88543898',
    first_name: 'Lex',
    last_name: 'test',
    email: 'lex@smoothterminal.com',
    mobile_number: '4049196695',
    preferences: {email: false, sms: true}
)
lex.save!

m1 = Manager.first
m1.email = 'lex@smoothterminal.com'
m1.save!

# Use the following tokens in POST requests:
m1.public_token
m1.api_key.auth_token

```

Use the public_token in in the POST request body to http://localhost:3000/api/v1/messages
Use  the auth_token for the Authorization bearer token value.

# SendGrid Errors

The Manager.email value must be valid or you'll get a 404 error from SendGrid and clues as to what happened.


# Bootstrapping


## To bootstrap a cloned project, that already has migrations (and code you don't want overridden in your models), run:
``` 
bundle exec rake db:drop db:create db:migrate db:seed
```

# Things to do before running Uhura in production

# Update user data

Ensure that each ser that you want to receive an Email or SMS messages exists in the **users** table.

The **users** table contains a `phone` field that is used by Uhura to send the user a text message (via Clearstream).

The `email` field is used to send the user an email via SendGrid.

# Add Administrate Gem

Add gems to Gemfile

```
gem 'highlands_auth', :git => 'git@github.com:highlands/highlands_auth.git', :branch => 'master'
gem "haml-rails" #, "~> 2.0"
```

## Create custom uhura route

###  config/routes.rb
```
mount HighlandsAuth::Engine => "/highlands_sso", :as => "auth"
```

## Install dashboards

bundle install

bundle exec rake highlands_auth:install:migrations

Merge original users migration with new administrate one.

## Export environment variables

```
export SSO_KEY='<YOUR_KEY>'
export SSO_SECRET='<YOUR_SECRET>'
export HIGHLANDS_AUTH_REDIRECT='http://localhost:3000'
export HIGHLANDS_AUTH_SUPPORT_EMAIL='franzejr@dailydrip.com'
export HIGHLANDS_SSO_EMAIL='franzejr+sso@gmail.com'
export HIGHLANDS_SSO_PASSWORD='<YOUR_PASSWORD>'

export HIGHLANDS_AUTH_DETAILS="true"
export HIGHLANDS_AUTH_DATA="true"
```


# Explanation of MessageVo, ReturnVo, MessageDirector and Message

## MessageVo
The message value object (MessageVo) is created in the MessagesController.
It includes ActiveModel::Validations that allow it to validate proper input from the request parameters (params hash).


## MessageDirector
The MessageDirector is a service object that is called in the MessagesController after the request parameters have been validated.

The MessageDirector.send method takes a messsage value object and returns a return value object (ret).

```
    ret = MessageDirector.send(message_vo)
    if !ret.error.nil?
      # Failed to deliver message
      render json: ret.error
    else
      render json: ret.value
    end
```

The MessageDirector's create_message method looks up the receiver's delivery preference (Email/SMS) and sets the target (Sendgrid/Clearstream) accordingly.

## ReturnVo
A return value object has two attributes: value and error.
Both value and error return a hash; This allows for a consistent response object.

### Error
Here's an example of an error:
```
{
    "status": 422,
    "data": null,
    "error": "Team name (X-Team-ID HTTP header) STA NOT found!"
}
```

### Success
Here's a success.  Note the consistency in the format of the response (both error and success responses have same hash keys).

#### Clearstream Success Response
```
{
    "status": 202,
    "data": {
        "clearstream_msg": "{\"id\":10,\"sent_to_clearstream\":\"2019-05-15T13:49:14.326Z\",\"sms_json\":\"{\\\"data\\\":{\\\"id\\\":118487,\\\"status\\\":\\\"QUEUED\\\",\\\"sent_at\\\":\\\"2019-05-15T13:49:55+00:00\\\",\\\"completed_at\\\":null,\\\"text\\\":{\\\"full\\\":\\\"Leadership Team: Come in now for 50% off all rolls!\\\",\\\"header\\\":\\\"Leadership Team\\\",\\\"body\\\":\\\"Come in now for 50% off all rolls!\\\"},\\\"lists\\\":[],\\\"subscribers\\\":[\\\"+17707651573\\\"],\\\"stats\\\":{\\\"recipients\\\":1,\\\"failures\\\":0,\\\"throughput\\\":0,\\\"replies\\\":0,\\\"opt_outs\\\":0},\\\"social\\\":{\\\"twitter\\\":{\\\"enabled\\\":false,\\\"id\\\":null,\\\"url\\\":null},\\\"facebook\\\":{\\\"enabled\\\":false,\\\"id\\\":null,\\\"url\\\":null}}}}\",\"got_response_at\":\"2019-05-15T13:49:14.571Z\",\"clearstream_response\":\"QUEUED\",\"created_at\":\"2019-05-15T13:49:14.335Z\",\"updated_at\":\"2019-05-15T13:49:14.571Z\"}"
    },
    "error": null
}
```

#### Sendgrid Success Response
```
{
    "status": 202,
    "data": {
        "sendgrid_msg": "{\"id\":6,\"sent_to_sendgrid\":\"2019-05-15T19:35:09.555Z\",\"mail_json\":{\"from\":{\"email\":\"app1@highlands.org\"},\"subject\":\"Picnic Saturday Week\",\"personalizations\":[{\"to\":[{\"email\":\"bob.p.k.brown@gmail.com\",\"name\":\"Bob Brown\"}],\"dynamic_template_data\":{\"header\":\"Karate Chop\",\"section1\":\"Try to imagine all life as you know it stopping instantaneously and every molecule in your body exploding at the speed of light.\",\"section2\":\"Maybe now you'll never slime a guy with a positron collider, huh?\",\"section3\":\"You will perish in flame, you and all your kind! Gatekeeper!\",\"button\":\"Reply\",\"email_subject\":\"Picnic Saturday Week\"}}],\"template_id\":\"d-f986df533e514f978f4460bedca50db0\"},\"got_response_at\":\"2019-05-15T19:35:09.639Z\",\"sendgrid_response\":\"202\",\"read_by_user_at\":null,\"created_at\":\"2019-05-15T19:35:09.555Z\",\"updated_at\":\"2019-05-15T19:35:09.639Z\"}"
    },
    "error": null
}
```

ret is created in MessageDirector.create_message(message_vo):

```
    if errs.size > 0
      ReturnVo.new({value: nil, error: error_json = return_error(errs, :unprocessable_entity)})
    else
      message = Message.create!(msg_target_id: msg_target_id,
                                manager_id: manager_id, # <= source of message (an application)
                                receiver_id: receiver.id,
                                team_id: team.id, # <= message coming from this team
                                email_subject: message_vo.email_subject,
                                email_message: message_vo.email_message,
                                template_id: template.id,
                                sms_message: message_vo.sms_message)

      ReturnVo.new({value: message, error: nil})
    end
```


## Message Table
The messages table has a msg_target_id to indicate 1=sendgrid or 2=clearstream
Once the message has been sent to Sendgrid, the sendgrid_msg_id field will be populated/linked to the SendgridMsg table entry
Ditto for Clearstream.
```
+----+---------------+-----------------+-------------------+------------+-------------+---------+--------------- 
| id | msg_target_id | sendgrid_msg_id | clearstream_msg_id | manager_id | receiver_id | team_id | email_subject  ...
+----+---------------+-----------------+--------------------+------------+-------------+---------+--------------- 
| 1  | 1             | 1               |                    | 1          | 2           | 1       | So maybe the r ...
+----+---------------+-----------------+--------------------+------------+-------------+---------+--------------- 
```

# Failure/Error: require File.expand_path('../config/environment', __dir__)

If you get this error, then you probably just need to source your .env file.

```
lex@k2 ~/Clients/Concur/Projects/uhura (feature/customize-admin-views) $ be rspec spec/controllers/api/v1/messages_spec.rb:130

An error occurred while loading ./spec/controllers/api/v1/messages_spec.rb.
Failure/Error: require File.expand_path('../config/environment', __dir__)

RuntimeError:
  The following environment variables should be set: TOKEN_AUTH_USER, TOKEN_AUTH_PASSWORD, PGUSER, PGPASSWORD, GITHUB_KEY, GITHUB_SECRET, GITHUB_TOKEN, SENDGRID_API_KEY, CLEARSTREAM_KEY, CLEARSTREAM_URL, CLEARSTREAM_DEFAULT_LIST_ID, TWITTER_ACCESS_TOKEN, TWITTER_ACCESS_TOKEN_SECRET, TWITTER_KEY, TWITTER_SECRET, SSO_KEY, SSO_SECRET, HIGHLANDS_AUTH_REDIRECT, HIGHLANDS_AUTH_SUPPORT_EMAIL, HIGHLANDS_SSO_EMAIL, HIGHLANDS_SSO_PASSWORD.
# /home/lex/.rvm/gems/ruby-2.6.1/gems/envied-0.9.1/lib/envied.rb:38:in `error_on_missing_variables!'
# /home/lex/.rvm/gems/ruby-2.6.1/gems/envied-0.9.1/lib/envied.rb:19:in `require'
# ./config/application.rb:8:in `<top (required)>'
# ./config/environment.rb:2:in `require_relative'
# ./config/environment.rb:2:in `<top (required)>'
# ./spec/rails_helper.rb:5:in `require'
# ./spec/rails_helper.rb:5:in `<top (required)>'
# ./spec/controllers/api/v1/messages_spec.rb:3:in `require'
# ./spec/controllers/api/v1/messages_spec.rb:3:in `<top (required)>'
Run options: include {:locations=>{"./spec/controllers/api/v1/messages_spec.rb"=>[130]}}

All examples were filtered out


Finished in 0.00074 seconds (files took 3.8 seconds to load)
0 examples, 0 failures, 1 error occurred outside of examples

lex@k2 ~/Clients/Concur/Projects/uhura (feature/customize-admin-views) $ . .env

lex@k2 ~/Clients/Concur/Projects/uhura (feature/customize-admin-views) $ be rspec spec/controllers/api/v1/messages_spec.rb:130
Run options: include {:locations=>{"./spec/controllers/api/v1/messages_spec.rb"=>[130]}}
. . .
```

# Error and Success Handling 

In Uhura, we catch errors early and handle them ASAP.

When all input has been validate and properly formed, after all errors have been handled, we make our request.
```
    if ret&.error && !ret.error.blank?
      # Uhura received bad input; unable to form request.
      render json: ret.error, status: :unprocessable_entity
    else
      # Both message_params_vo, manager_team_vo params are valid.
      message_vo = MessageVo.new(message_params_vo, manager_team_vo)
      # Send message (MessageDirector will determine if its an Email or SMS message).
      ret = MessageDirector.send(message_vo)
      if ret&.error && !ret.error.blank?
        render json: ret.error, status: :unprocessable_entity
      else
        render json: ret.value
      end
    end
```
When we get the response, we check for errors first.

Again, success processing comes after error handling.
