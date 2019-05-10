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


# Add email account for testing
In Rails console:

```
lex = User.create!(
    first_name: 'Lex',
    last_name: 'text',
    email: 'lex@smoothterminal.com',
    preferences: {email: true, sms: true}
)
lex.save!

m1 = Manager.first
m1.email = 'lex@smoothterminal.com'
m1.save!

# Use new keys in curl commands:
uhura> m1.public_token
"69ff29903f2ea2f40d14"

uhura> m1.api_key.auth_token
"456003882429ee7da561"

```

# SendGrid Errors

The Manager.email value must be valid or you'll get a 404 error from SendGrid and clues as to what happened.



