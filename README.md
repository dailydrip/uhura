# Intial App Configuration

## Create Rails 6 app
```
$ create-rails6-app uhura
Fetching https://github.com/rails/rails.git
Fetching gem metadata from https://rubygems.org/.............
Fetching gem metadata from https://rubygems.org/............
Fetching gem metadata from https://rubygems.org/............
Resolving dependencies...
Using rake 12.3.2
Using concurrent-ruby 1.1.5
Using i18n 1.6.0
Using minitest 5.11.3
Using thread_safe 0.3.6
Using tzinfo 1.2.5
Using zeitwerk 2.1.5
Using activesupport 6.1.0.alpha from https://github.com/rails/rails.git (at master@7575242)
Using builder 3.2.3
Using erubi 1.8.0
Using mini_portile2 2.4.0
Using nokogiri 1.10.3
Using rails-dom-testing 2.0.3
Using crass 1.0.4
Using loofah 2.2.3
Using rails-html-sanitizer 1.0.4
Using actionview 6.1.0.alpha from https://github.com/rails/rails.git (at master@7575242)
Using rack 2.0.7
Using rack-test 1.1.0
Using actionpack 6.1.0.alpha from https://github.com/rails/rails.git (at master@7575242)
Using nio4r 2.3.1
Using websocket-extensions 0.1.3
Using websocket-driver 0.7.0
Using actioncable 6.1.0.alpha from https://github.com/rails/rails.git (at master@7575242)
Using globalid 0.4.2
Using activejob 6.1.0.alpha from https://github.com/rails/rails.git (at master@7575242)
Using activemodel 6.1.0.alpha from https://github.com/rails/rails.git (at master@7575242)
Using activerecord 6.1.0.alpha from https://github.com/rails/rails.git (at master@7575242)
Using mimemagic 0.3.3
Using marcel 0.3.3
Using activestorage 6.1.0.alpha from https://github.com/rails/rails.git (at master@7575242)
Using mini_mime 1.0.1
Using mail 2.7.1
Using actionmailbox 6.1.0.alpha from https://github.com/rails/rails.git (at master@7575242)
Using actionmailer 6.1.0.alpha from https://github.com/rails/rails.git (at master@7575242)
Using actiontext 6.1.0.alpha from https://github.com/rails/rails.git (at master@7575242)
Using bundler 2.0.1
Using method_source 0.9.2
Using thor 0.20.3
Using railties 6.1.0.alpha from https://github.com/rails/rails.git (at master@7575242)
Using sprockets 3.7.2
Using sprockets-rails 3.2.1
Using rails 6.1.0.alpha from https://github.com/rails/rails.git (at master@7575242)
Bundle complete! 1 Gemfile dependency, 43 gems now installed.
Use `bundle info [gemname]` to see where a bundled gem is installed.
       exist  
      create  README.md
      create  Rakefile
      create  .ruby-version
      create  config.ru
      create  .gitignore
       force  Gemfile
         run  git init from "."
Initialized empty Git repository in /home/lex/Clients/Concur/Projects/uhura/.git/
      create  package.json
      create  app
      create  app/assets/config/manifest.js
      create  app/assets/stylesheets/application.css
      create  app/channels/application_cable/channel.rb
      create  app/channels/application_cable/connection.rb
      create  app/controllers/application_controller.rb
      create  app/helpers/application_helper.rb
      create  app/javascript/channels/consumer.js
      create  app/javascript/channels/index.js
      create  app/javascript/packs/application.js
      create  app/jobs/application_job.rb
      create  app/mailers/application_mailer.rb
      create  app/models/application_record.rb
      create  app/views/layouts/application.html.erb
      create  app/views/layouts/mailer.html.erb
      create  app/views/layouts/mailer.text.erb
      create  app/assets/images/.keep
      create  app/controllers/concerns/.keep
      create  app/models/concerns/.keep
      create  bin
      create  bin/rails
      create  bin/rake
      create  bin/setup
      create  bin/yarn
      create  config
      create  config/routes.rb
      create  config/application.rb
      create  config/environment.rb
      create  config/cable.yml
      create  config/puma.rb
      create  config/storage.yml
      create  config/environments
      create  config/environments/development.rb
      create  config/environments/production.rb
      create  config/environments/test.rb
      create  config/initializers
      create  config/initializers/application_controller_renderer.rb
      create  config/initializers/assets.rb
      create  config/initializers/backtrace_silencers.rb
      create  config/initializers/content_security_policy.rb
      create  config/initializers/cookies_serializer.rb
      create  config/initializers/cors.rb
      create  config/initializers/filter_parameter_logging.rb
      create  config/initializers/inflections.rb
      create  config/initializers/mime_types.rb
      create  config/initializers/new_framework_defaults_6_0.rb
      create  config/initializers/wrap_parameters.rb
      create  config/locales
      create  config/locales/en.yml
      create  config/master.key
      append  .gitignore
      create  config/boot.rb
      create  config/database.yml
      create  db
      create  db/seeds.rb
      create  lib
      create  lib/tasks
      create  lib/tasks/.keep
      create  lib/assets
      create  lib/assets/.keep
      create  log
      create  log/.keep
      create  public
      create  public/404.html
      create  public/422.html
      create  public/500.html
      create  public/apple-touch-icon-precomposed.png
      create  public/apple-touch-icon.png
      create  public/favicon.ico
      create  public/robots.txt
      create  tmp
      create  tmp/.keep
      create  tmp/cache
      create  tmp/cache/assets
      create  vendor
      create  vendor/.keep
      create  test/fixtures
      create  test/fixtures/.keep
      create  test/fixtures/files
      create  test/fixtures/files/.keep
      create  test/controllers
      create  test/controllers/.keep
      create  test/mailers
      create  test/mailers/.keep
      create  test/models
      create  test/models/.keep
      create  test/helpers
      create  test/helpers/.keep
      create  test/integration
      create  test/integration/.keep
      create  test/channels/application_cable/connection_test.rb
      create  test/test_helper.rb
      create  test/system
      create  test/system/.keep
      create  test/application_system_test_case.rb
      create  storage
      create  storage/.keep
      create  tmp/storage
      create  tmp/storage/.keep
      remove  config/initializers/cors.rb
      remove  config/initializers/new_framework_defaults_6_0.rb
         run  bundle install
Fetching https://github.com/rails/webpacker.git
Fetching https://github.com/rails/web-console.git
The dependency tzinfo-data (>= 0) will be unused by any of the platforms Bundler is installing for. Bundler is installing for ruby but the dependency is only for x86-mingw32, x86-mswin32, x64-mingw32, java. To add those platforms to the bundle, run `bundle lock --add-platform x86-mingw32 x86-mswin32 x64-mingw32 java`.
Fetching gem metadata from https://rubygems.org/............
Fetching gem metadata from https://rubygems.org/.
Resolving dependencies...
Bundler could not find compatible versions for gem "activesupport":
  In Gemfile:
    rails was resolved to 6.1.0.alpha, which depends on
      activesupport (= 6.1.0.alpha)

    webpacker was resolved to 4.0.2, which depends on
      activesupport (>= 4.2)

Bundler could not find compatible versions for gem "railties":
  In Gemfile:
    rails was resolved to 6.1.0.alpha, which depends on
      railties (= 6.1.0.alpha)

    sass-rails (~> 5) was resolved to 5.0.4, which depends on
      railties (>= 4.0.0, < 5.0)

    web-console was resolved to 4.0.0, which depends on
      railties (>= 6.0.0.a)

    webpacker was resolved to 4.0.2, which depends on
      railties (>= 4.2)
         run  bundle binstubs bundler
The git source https://github.com/rails/webpacker.git is not yet checked out. Please run `bundle install` before trying to start
your application
       rails  webpacker:install
The git source https://github.com/rails/webpacker.git is not yet checked out. Please run `bundle install` before trying to start your application
The git source https://github.com/rails/webpacker.git is not yet checked out. Please run `bundle install` before trying to start your application

Having problems with webpack & webpacker?
If so, run : bundle pack and bundle install --path vendor/cache to solve it.


Create a lib/uhura directory and a lib/lib/uhura.rb file.

# Update Gemfile - At least add following:

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec'
  gem 'rspec-rails'
  gem 'webmock'
  gem 'awesome_print'
  gem 'hirb'
end


Add envied gem.
Add EnvFile
Run bundle exec envied init:rails
Run be envied check
 
# Add to config/application.rb
Bundler.require(*Rails.groups)
ENVied.require(*ENV['ENVIED_GROUPS'] || Rails.groups)

Run bundle exec rails generate rspec:install

```

### Command History
```
 2075  create-rails6-app uhura
 2076  cp jump1/.env uhura/
 2077  gem uhura/.env 
 2078  ge uhura/.env 
 2079  cp jump1/Gemfile uhura/
 2080  cp jump1/Envfile uhura/
 2081  cd uhura
 2082  mhe
 2083  bundle
 2084  bundle install
 2085  bundle exec envied init:rails
 2086  be envied check
 2087  bundle exec rails generate rspec:install
 2088  bundle exec rails generate rspec:install
 2089  be rake webpacker:install
 2090  bundle exec rails generate rspec:install
```

## Gemfile
```
source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.1'

gem 'rails', '~> 6.0.0.rc1'   # You can bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'pg', '>= 0.18', '< 2.0'  # Use postgresql as the database for Active Record
gem 'puma', '~> 3.11'         # Use Puma as the app server
gem 'sass-rails', '~> 5'      # Use SCSS for stylesheets
gem 'webpacker', '~> 4.0'     # Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'turbolinks', '~> 5'      # Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'jbuilder', '~> 2.5'      # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder

# gem 'redis', '~> 4.0'         # Use Redis adapter to run Action Cable in production
# gem 'bcrypt', '~> 3.1.7'      # Use Active Model has_secure_password
# gem 'image_processing', '~> 1.2' # Use Active Storage variant
# gem 'bootsnap', '>= 1.4.2', require: false  # Reduces boot times through caching; required in config/boot.rb

gem 'rack-timeout'            # Configure Rails middleware with a default timeout of 15
gem 'envied'                  # Ensure presence and type of your app's ENV-variables
gem 'sendgrid-ruby'           # For sending emails

# For Clearstream
gem 'faraday'
gem 'faraday_middleware'
gem 'json'
gem 'typhoeus'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec'
  gem 'rspec-rails'
  gem 'webmock'
  gem 'awesome_print'
  gem 'hirb'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  gem 'webdrivers'    # Easy installation and use of web drivers to run system tests with browsers
  gem 'database_cleaner'
  gem 'factory_bot'
  gem 'faker'
end

gem 'bootstrap', '~> 4.3', '>= 4.3.1'
gem 'font-awesome-sass', '~> 5.6', '>= 5.6.1'
# gem 'administrate', github: 'l3x/administrate'
# gem 'devise', '~> 4.6', '>= 4.6.1'
# gem 'devise-bootstrapped', github: 'l3x/devise-bootstrapped'
# gem 'friendly_id', '~> 5.2', '>= 5.2.5'
# gem 'gravatar_image_tag', github: 'mdeering/gravatar_image_tag'
# gem 'mini_magick', '~> 4.9', '>= 4.9.2'
# gem 'name_of_person', '~> 1.1'
# gem 'omniauth-facebook', '~> 5.0'
# gem 'omniauth-github', '~> 1.3'
# gem 'omniauth-twitter', '~> 1.4'
```

## config/application.rb
```
module Uhura
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1
```

Try to install rspec:
```
$ bundle exec rails generate rspec:install
Traceback (most recent call last):
	15: from bin/rails:4:in `<main>'
	14: from bin/rails:4:in `require'
	13: from /home/lex/.rvm/gems/ruby-2.6.1/gems/railties-6.0.0.rc1/lib/rails/commands.rb:18:in `<top (required)>'
	12: from /home/lex/.rvm/gems/ruby-2.6.1/gems/railties-6.0.0.rc1/lib/rails/command.rb:46:in `invoke'
	11: from /home/lex/.rvm/gems/ruby-2.6.1/gems/railties-6.0.0.rc1/lib/rails/command/base.rb:65:in `perform'
	10: from /home/lex/.rvm/gems/ruby-2.6.1/gems/thor-0.20.3/lib/thor.rb:387:in `dispatch'
	 9: from /home/lex/.rvm/gems/ruby-2.6.1/gems/thor-0.20.3/lib/thor/invocation.rb:126:in `invoke_command'
	 8: from /home/lex/.rvm/gems/ruby-2.6.1/gems/thor-0.20.3/lib/thor/command.rb:27:in `run'
	 7: from /home/lex/.rvm/gems/ruby-2.6.1/gems/railties-6.0.0.rc1/lib/rails/commands/generate/generate_command.rb:21:in `perform'
	 6: from /home/lex/.rvm/gems/ruby-2.6.1/gems/railties-6.0.0.rc1/lib/rails/command/actions.rb:14:in `require_application_and_environment!'
	 5: from /home/lex/.rvm/gems/ruby-2.6.1/gems/railties-6.0.0.rc1/lib/rails/command/actions.rb:22:in `require_application!'
	 4: from /home/lex/.rvm/gems/ruby-2.6.1/gems/railties-6.0.0.rc1/lib/rails/command/actions.rb:22:in `require'
	 3: from /home/lex/Clients/Concur/Projects/uhura/config/application.rb:10:in `<top (required)>'
	 2: from /home/lex/Clients/Concur/Projects/uhura/config/application.rb:11:in `<module:Uhura>'
	 1: from /home/lex/Clients/Concur/Projects/uhura/config/application.rb:13:in `<class:Application>'
/home/lex/.rvm/gems/ruby-2.6.1/gems/railties-6.0.0.rc1/lib/rails/application/configuration.rb:150:in `load_defaults': Unknown version "6.1" (RuntimeError)
```


## config/application.rb
Change 6.1 to 6.0
```
module Uhura
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
```

Try to install rspec:
```
$ bundle exec rails generate rspec:install
RAILS_ENV=development environment is not defined in config/webpacker.yml, falling back to production environment
      create  .rspec
      create  spec
      create  spec/spec_helper.rb
      create  spec/rails_helper.rb
```

## Install webpacker
```
$ bundle exec rails generate rspec:install
RAILS_ENV=development environment is not defined in config/webpacker.yml, falling back to production environment
      create  .rspec
      create  spec
      create  spec/spec_helper.rb
      create  spec/rails_helper.rb
[lex@k2 uhura]$ be rake webpacker:install
RAILS_ENV=development environment is not defined in config/webpacker.yml, falling back to production environment
      create  config/webpacker.yml
Copying webpack core config
      create  config/webpack
      create  config/webpack/development.js
      create  config/webpack/environment.js
      create  config/webpack/production.js
      create  config/webpack/test.js
Copying postcss.config.js to app root directory
      create  postcss.config.js
Copying babel.config.js to app root directory
      create  babel.config.js
Copying .browserslistrc to app root directory
      create  .browserslistrc
The JavaScript app source directory already exists
       apply  /home/lex/.rvm/gems/ruby-2.6.1/gems/webpacker-4.0.2/lib/install/binstubs.rb
  Copying binstubs
       exist    bin
      create    bin/webpack
      create    bin/webpack-dev-server
      append  .gitignore
Installing all JavaScript dependencies [4.0.2]
         run  yarn add @rails/webpacker from "."
yarn add v1.15.2
info No lockfile found.
[1/4] Resolving packages...
[2/4] Fetching packages...
info fsevents@1.2.9: The platform "linux" is incompatible with this module.
info "fsevents@1.2.9" is an optional dependency and failed compatibility check. Excluding it from installation.
[3/4] Linking dependencies...
[4/4] Building fresh packages...
success Saved lockfile.
success Saved 585 new dependencies.
info Direct dependencies
├─ @rails/actioncable@6.0.0-alpha
├─ @rails/activestorage@6.0.0-alpha
├─ @rails/ujs@6.0.0-alpha
├─ @rails/webpacker@4.0.2
└─ turbolinks@5.2.0
info All dependencies
├─ @babel/core@7.4.4
├─ @babel/helper-builder-binary-assignment-operator-visitor@7.1.0
├─ @babel/helper-call-delegate@7.4.4
. . .
├─ webpack-dev-middleware@3.6.2
├─ webpack-dev-server@3.3.1
└─ websocket-extensions@0.1.3
Done in 4.24s.
Webpacker successfully installed
```

## Re-install Rspec
```
 $ bundle exec rails generate rspec:install
    identical  .rspec
        exist  spec
    identical  spec/spec_helper.rb
    identical  spec/rails_helper.rb
```
No warnings about webpack!


# Exchang-ify Uhura

## db/seeds.rb
```
# rubocop:disable Rails/Output
puts 'Creating a Manager'
manager = Manager.create!(name: 'Generated Manager')

puts 'Creating an Api Key'
ApiKey.create!(manager: manager)
```

## Create Manager Migrations

NOTE: Manager table represents non-interactive service accounts (that make API calls)

* Manager
* ApiKey

```
be rails g model Manager name public_token
#be rails g model ApiKey auth_token:string{10}:uniq manager:references
be rails g model ApiKey auth_token:token manager:references
be rake db:drop db:create db:migrate db:seed
```

## Generated db/schema.rb
```
ActiveRecord::Schema.define(version: 2019_04_30_202506) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "api_keys", force: :cascade do |t|
    t.string "auth_token", limit: 10
    t.bigint "manager_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["auth_token"], name: "index_api_keys_on_auth_token", unique: true
    t.index ["manager_id"], name: "index_api_keys_on_manager_id"
  end

  create_table "managers", force: :cascade do |t|
    t.string "name"
    t.string "public_token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "api_keys", "managers"
end

```

# Add Administration Framework

Found ApiKey usage in exchequer-server

## app/admin/api_key.rb
```
ActiveAdmin.register ApiKey do
  permit_params do
    %i[auth_token manager_id]
  end

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :manager
      f.input :auth_token unless f.object.new_record?
    end
    f.actions
  end
end
```

Clearly, we need to add and Administrative Application to view ApiKeys.

## Add Administrate

See https://github.com/l3x/administrate

### Add Gem
```
gem 'administrate', github: 'l3x/administrate'
bundle install
```

### Install Administrate app files
```
$ be rails generate administrate:install
       route  namespace :admin do
    resources :api_keys
    resources :managers

    root to: "api_keys#index"
  end
      create  app/controllers/admin/application_controller.rb
      create  app/dashboards/api_key_dashboard.rb
      create  app/controllers/admin/api_keys_controller.rb
      create  app/dashboards/manager_dashboard.rb
      create  app/controllers/admin/managers_controller.rb
```

#### Change root to managers
##### config/routes.rb
```
root to: "managers#index"
```



## Create API Migrations

NOTE: Manager table represents non-interactive service accounts (that make API calls)

* Team
* Sendgrid
* Clearstream

```
be rails g model Team name:string:uniq
be rails g model Template name:string:uniq sendgrid_id

# manager == app
be rails g model Message manager:references user:references team:references email_subject email_message:text template:references sms_message:text

# Create! message upon receipt from app
be rails g model Sendgrid message:references sent_to_sendgrid:datetime sendgrid_response:text read:datetime 
be rails g model Clearstream message:references sent_to_clearstream:datetime clearstream_response:text  --test-framework=rspec

be rake db:drop db:create db:migrate db:seed
```

### Note
If we get more email or sms providers, we can refactor using STI.

## Generated db/schema.rb
```
ActiveRecord::Schema.define(version: 2019_04_30_202506) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "api_keys", force: :cascade do |t|
    t.string "auth_token", limit: 10
    t.bigint "manager_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["auth_token"], name: "index_api_keys_on_auth_token", unique: true
    t.index ["manager_id"], name: "index_api_keys_on_manager_id"
  end

  create_table "managers", force: :cascade do |t|
    t.string "name"
    t.string "public_token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "api_keys", "managers"
end

```

## RSpec/Shoulda Matchers Change

```
Testing started at 11:04 AM ...
/bin/bash -c "/home/lex/.rvm/bin/rvm ruby-2.6.1 do bundle exec /home/lex/.rvm/rubies/ruby-2.6.1/bin/ruby /home/lex/.rvm/gems/ruby-2.6.1/bin/rspec /home/lex/Clients/Concur/Projects/uhura --require teamcity/spec/runner/formatter/teamcity/formatter --format Spec::Runner::Formatter::TeamcityFormatter --pattern '**/*_spec.rb' --no-color"

Expected ApiKey to validate that :manager cannot be empty/falsy, but
this could not be proved.
  After setting :manager to ‹nil›, the matcher expected the ApiKey to be
  invalid and to produce the validation error "can't be blank" on
  :manager. The record was indeed invalid, but it produced these
  validation errors instead:

  * manager: ["must exist"]

  0) ApiKey validations should validate that :manager cannot be empty/falsy
     Failure/Error: it { should validate_presence_of(:manager) }

       Expected ApiKey to validate that :manager cannot be empty/falsy, but
       this could not be proved.
         After setting :manager to ‹nil›, the matcher expected the ApiKey to be
         invalid and to produce the validation error "can't be blank" on
         :manager. The record was indeed invalid, but it produced these
         validation errors instead:

         * manager: ["must exist"]
     # ./spec/models/api_key_spec.rb:5:in `block (3 levels) in <top (required)>'
```

### Fix
https://github.com/thoughtbot/shoulda-matchers/issues/1095


# Up & Running Shortcuts

Generate Rails models
Copy back logic to .rb model files


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
    phone: '4048844200',
    preferences: {email: false, sms: true}
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


# Bootstrapping


## To bootstrap a cloned project, that already has migrations (and code you don't want overridden in your models), run:
``` 
bundle exec rake db:drop db:create db:migrate db:seed
```

## In the begining of this project we ran following script to create models and database migrations:

```
uhu-drop-tables-gen-and-seed
```

# Things to do before running Uhura in production

# Update user data

Ensure that each ser that you want to receive an Email or SMS messages exists in the **users** table.

The **users** table contains a `phone` field that is used by Uhura to send the user a text message (via Clearstream).

The `email` field is used to send the user an email via SendGrid.

