﻿# Uhura

[![Build Status](https://semaphoreci.com/api/v1/dailydrip/uhura/branches/master/badge.svg)](https://semaphoreci.com/dailydrip/uhura)


[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/dailydrip/uhura)


Yet another rails boilerplate, but now using cutting edge libraries.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

- Ruby 2.6
- Rails 6

##### Environment variables

To work with postgres, you must have `PGUSER` and `PGPASSWORD` as environment variables.

To be able to see the admin and the app in test environment, you must have `ADMIN_NAME` and `ADMIN_PASSWORD` as environment variables.

### Installing

1. Install Rails at the command prompt if you haven't yet:

        $ gem install rails

2. Install Bundler to manage this application's dependencies:

        $ gem install bundler

3. In project root directory, install dependencies (in vendor directory):

        $ bundle install

4. Update npm packages:

        $ yarn install --check-files

5. Go to `http://localhost:3000` and you'll see the app.

#### Installation Exceptions

You might need to install a specfic version of bundler if you get this message:

```
$ bundle install
Traceback (most recent call last):
	2: from /home/lex/.gem/ruby/2.6.0/bin/bundle:23:in `<main>'
	1: from /usr/lib/ruby/2.6.0/rubygems.rb:302:in `activate_bin_path'
/usr/lib/ruby/2.6.0/rubygems.rb:283:in `find_spec_for_exe': Could not find 'bundler' (1.17.2) required by your /home/lex/Clients/Concur/Projects/uhura/Gemfile.lock. (Gem::GemNotFoundException)
To update to the latest version installed on your system, run `bundle update --bundler`.
To install the missing version, run `gem install bundler:1.17.2`

```
If that happens, do as it recommands and run `gem install bundler:1.17.2`

## Running the tests

### rspec tests

```sh
$ rspec
```

### spinach tests

```sh
$ spinach
```

## Deployment

You can deploy this [directly to Heroku](https://heroku.com/deploy?template=https://github.com/dailydrip/uhura), if you want to.

## Test

The application uses BASIC AUTH when in `test`. We use the same password and username for the admin.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details



# NEW STUFF

Add this to top of spec/rails_helper.rb

```
require 'database_cleaner'
```

## Add lib/uhura

## Clear Cache
```
uhura> Rails.cache.clear
rmrf tmp/cache/bootsnap-compile-cache/
mv node_modules /tmp/
pushd ..
make-zip-here uhura
popd
mv /tmp/node_modules .
```

## Reset DB
```
be rake db:drop  db:create  db:migrate  db:seed
```

## Run Fake Api Server from Command Lin3
Load .env first to export API_VER and API_ENDPOINT environment variables.
```
[lex@k2 uhura]$ . .env
[lex@k2 uhura]$ ruby /home/lex/Clients/Concur/Projects/uhura/spec/api/fake_api_server.rb 
[2019-03-15 23:30:47] INFO  WEBrick 1.4.2
[2019-03-15 23:30:47] INFO  ruby 2.6.1 (2019-01-30) [x86_64-linux]
[2019-03-15 23:30:47] INFO  WEBrick::HTTPServer#start: pid=2592 port=8080
>>-sg_emails/1
::1 - - [15/Mar/2019:23:30:50 EDT] "GET /api/v1/sg_emails/1 HTTP/1.1" 200 259
- -> /api/v1/sg_emails/1
```

### .env File Contents
```
export APP_NAME='uhura'
export API_VER_NO="$(cat "lib/$(basename ${APP_NAME})/version.rb" | grep VERSION | head -n 1 | awk '{print $3}' | tr -d "'" | cut -d '.' -f1)"
export API_VER="api/v${API_VER_NO}"
export BASE_URI='http://localhost:3000'
export API_ENDPOINT="${BASE_URI}/${API_VER}/"
```

## Run Fake Api Server from Command Line -- with some 404's
```
[lex@k2 uhura]$ ruby /home/lex/Clients/Concur/Projects/uhura/spec/api/fake_api_server.rb 
[2019-03-15 17:21:53] INFO  WEBrick 1.4.2
[2019-03-15 17:21:53] INFO  ruby 2.6.1 (2019-01-30) [x86_64-linux]
[2019-03-15 17:21:53] INFO  WEBrick::HTTPServer#start: pid=7602 port=8080
::1 - - [15/Mar/2019:17:21:58 EDT] "GET /sg_emails/1 HTTP/1.1" 404 0
- -> /sg_emails/1
::1 - - [15/Mar/2019:17:26:27 EDT] "GET /sg_emails/1 HTTP/1.1" 404 0
- -> /sg_emails/1
::1 - - [15/Mar/2019:17:27:21 EDT] "GET /sg_emails/1 HTTP/1.1" 404 0
- -> /sg_emails/1
::1 - - [15/Mar/2019:17:28:40 EDT] "GET /sg_emails/1 HTTP/1.1" 404 0
- -> /sg_emails/1
::1 - - [15/Mar/2019:17:28:54 EDT] "GET /api/v1/sg_emails/1 HTTP/1.1" 404 0
- -> /api/v1/sg_emails/1
::1 - - [15/Mar/2019:17:32:24 EDT] "GET /posts/1 HTTP/1.1" 200 79
- -> /posts/1
```

## Return Payloads
We'll start with two status codes:
* 200 = Success
* 500 = Error

### Successful request:
```
{
  "status": "200",
  "data": {
    /* Application-specific data would go here. */
  },
  "message": null /* Or optional success message */
}
```
#### Example
```
{
    "status": "200",
    "data": {
        "id": 4,
        "from_email": "lex.nospam@gmail.com",
        "to_email": "lex.sheehan@gmail.com",
        "subject": "A test from Rails",
        "content": "How R U?",
        "response_status_code": null,
        "created_at": "2019-03-20T23:33:17.292Z",
        "updated_at": "2019-03-20T23:33:17.292Z"
    },
    "message": null
}
```

### Failed request - unprocessable entity
```
{
  "status": "422",
  "data": null, /* or optional error payload */
  "message": "Error xyz has occurred"
}
```
### Failed request - server error
```
{
  "status": "500",
  "data": null, /* or optional error payload */
  "message": "Error xyz has occurred"
}
```

## Suppress Annoying Warnings

To remove the following Warnings when running be rspec...
```
/usr/lib/ruby/gems/2.6.0/gems/shoulda-matchers-2.8.0/lib/shoulda/matchers/active_model/validate_inclusion_of_matcher.rb:251: warning: BigDecimal.new is deprecated; use BigDecimal() method instead.
DEPRECATION WARNING: Single arity template handlers are deprecated.  Template handlers must
now accept two parameters, the view object and the source for the view object.
Change:
  >> Class#call(template)
To:
  >> Class#call(template, source)
 (called from <top (required)> at /home/lex/Clients/Concur/Projects/uhura/config/environment.rb:7)
DEPRECATION WARNING: action_view.finalize_compiled_template_methods is deprecated and has no effect (called from <top (required)> at /home/lex/Clients/Concur/Projects/uhura/config/environment.rb:7)

```

...Add the ActiveSupport::Deprecation.silenced = true to your config/application.rb file

```
module Uhura
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Don't generate system test files.
    config.generators.system_tests = nil

    # Suppress warnings when running rspec
    ActiveSupport::Deprecation.silenced = true
  end
end
```

# A Note About the Rspec

## Avoid Metaprogramming, especially in RSpec

I read this: https://blog.schembri.me/post/testing-apis-in-ruby-with-rspec/

I thought I found a better way to test API's.

"A little gem named Cuba. Cuba gives us a simple DSL to define routes and responses, which is really all we need. It also doesn’t pull in a bunch of unnecessary dependencies."

I found it to be handy to test JSON API's.  Without changing code or configuration, I could run a Cuba server in one terminal and and run curl commands in another (or just use Postman).

 ```
$ ruby /home/lex/Clients/Concur/Projects/uhura/spec/api/fake_api_server.rb 
```

When running Rspec tests, the Rspec file includes some meta programming magic:

```
RSpec.describe SgEmailApi do

  around &method(:with_fake_server)

  attr_accessor :sg_email

  describe '.post' do
    it 'returns a valid SgEmail object' do
      api_sg_email = SgEmailApi.post
      expect(api_sg_email[:status]).to eq '200'
    end
  end

end
```

See that "around" symbol? Well, that piece of shit looks nifty, but caused much frustration.

When it comes to code, magic sucks.  So, this fancy API test framework won't be around long.

Did you read that "Testing APIs in Ruby: An overview" article?  The fonts, colors and images are snazzy, but what that Jamie left out was what happens when you add more than one Rspec test.

 
## Use Request Specs

## Curls

### Before Fix 
#### app/controllers/api/v1/sg_emails_controller.rb
```
      render json: return_error(@sg_email.errors)
```
#### In Terminal
```
$ curl --verbose -d 'Content-Type=application/json' -u 'admin:Zm96_$F:p4zPt-r4' -X POST http://localhost:3000/api/v1/sg_emails
Note: Unnecessary use of -X or --request, POST is already inferred.
*   Trying ::1...
* TCP_NODELAY set
* connect to ::1 port 3000 failed: Connection refused
*   Trying 127.0.0.1...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 3000 (#0)
* Server auth using Basic with user 'admin'
> POST /api/v1/sg_emails HTTP/1.1
> Host: localhost:3000
> Authorization: Basic YWRtaW46Wm05Nl8kRjpwNHpQdC1yNA==
> User-Agent: curl/7.64.0
> Accept: */*
> Content-Length: 29
> Content-Type: application/x-www-form-urlencoded
> 
* upload completely sent off: 29 out of 29 bytes
< HTTP/1.1 200 OK
< X-Frame-Options: SAMEORIGIN
< X-XSS-Protection: 1; mode=block
< X-Content-Type-Options: nosniff
< X-Download-Options: noopen
< X-Permitted-Cross-Domain-Policies: none
< Referrer-Policy: strict-origin-when-cross-origin
< Content-Type: application/json; charset=utf-8
< ETag: W/"dee66c55f3efe92c9e16197d8f73dfeb"
< Cache-Control: max-age=0, private, must-revalidate
< X-Request-Id: 48fbc4ae-2a30-4ad7-9efe-14483cc13a7f
< X-Runtime: 0.008309
< Transfer-Encoding: chunked
< 
* Connection #0 to host localhost left intact
{"status":422,"data":null,"message":{"from_email":["can't be blank","is invalid"],"to_email":["can't be blank","is invalid","should be different than from_email"],"subject":["can't be blank"],"content":["can't be blank"]}}
```

### After Fix 
#### app/controllers/api/v1/sg_emails_controller.rb
```
      error_json = return_error(@sg_email.errors)
      render json: error_json, status: error_json[:status]
```
#### In Terminal
```
$ curl --verbose -d 'Content-Type=application/json' -u 'admin:Zm96_$F:p4zPt-r4' -X POST http://localhost:3000/api/v1/sg_emails
Note: Unnecessary use of -X or --request, POST is already inferred.
*   Trying ::1...
* TCP_NODELAY set
* connect to ::1 port 3000 failed: Connection refused
*   Trying 127.0.0.1...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 3000 (#0)
* Server auth using Basic with user 'admin'
> POST /api/v1/sg_emails HTTP/1.1
> Host: localhost:3000
> Authorization: Basic YWRtaW46Wm05Nl8kRjpwNHpQdC1yNA==
> User-Agent: curl/7.64.0
> Accept: */*
> Content-Length: 29
> Content-Type: application/x-www-form-urlencoded
> 
* upload completely sent off: 29 out of 29 bytes
< HTTP/1.1 422 Unprocessable Entity
< X-Frame-Options: SAMEORIGIN
< X-XSS-Protection: 1; mode=block
< X-Content-Type-Options: nosniff
< X-Download-Options: noopen
< X-Permitted-Cross-Domain-Policies: none
< Referrer-Policy: strict-origin-when-cross-origin
< Content-Type: application/json; charset=utf-8
< Cache-Control: no-cache
< X-Request-Id: b1c48d00-42e5-438f-ac3e-471775777ad8
< X-Runtime: 0.243982
< Transfer-Encoding: chunked
< 
* Connection #0 to host localhost left intact
{"status":422,"data":null,"message":{"from_email":["can't be blank","is invalid"],"to_email":["can't be blank","is invalid","should be different than from_email"],"subject":["can't be blank"],"content":["can't be blank"]}}
```

## Use Encrypted Rails Secrets .yml files
See https://www.engineyard.com/blog/encrypted-rails-secrets-on-rails-5.1

### Create Files
Following will open vscodium editor 
```
EDITOR="vscodium --wait" bundle exec rails credentials:edit --environment development
EDITOR="vscodium --wait" bundle exec rails credentials:edit --environment test
EDITOR="vscodium --wait" bundle exec rails credentials:edit --environment production
```

Make contents look similar to:
```
# aws:
#   access_key_id: 123
#   secret_access_key: 345

postgres:
  #database: uhura_development
  username: <USER NAME HERE>
  password: <PASSWORD NAME HERE>

sendgrid:
  api_key: <API KEY  HERE>

basic_auth:
  admin_name: admin
  admin_password: <PLAINTEX PASSWORD HERE>
```

### Example Usage
```
module Admin
  class ApplicationController < Administrate::ApplicationController
    http_basic_authenticate_with(
      name: Rails.application.credentials.basic_auth[:admin_name],
      password: Rails.application.credentials.basic_auth[:admin_password]
    )
```

### Semaphore

```
      env_vars:
        - name: RAILS_ENV
          value: test
        - name: RAILS_MASTER_KEY
          value: "$RAILS_MASTER_KEY"
```

#### Install Semaphore CLI

curl https://storage.googleapis.com/sem-cli-releases/get.sh | bash
sem connect smoothterminal.semaphoreci.com <PASSWORD>

#### Create Semaphore Secret yml File

##### config/credentials/uhura_rails_secret.yml
```
# sem_uhura_rails_secret.yml
apiVersion: v1beta
kind: Secret
metadata:
  name: uhura
data:
  env_vars:
    - name: RAILS_MASTER_KEY
      value: <KEY VALUE GOES HERE>
```      
sem create -f config/credentials/uhura_rails_secret.yml 