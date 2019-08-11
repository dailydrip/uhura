# Uhura

Uhura is a communication system that centralizes communication preferences, policies and statistcs which is comprised of:

* A Ruby on Rails based API server (Uhura) for processing communications
* A UI for the administration of communication functions of Uhura
* A Uhura Ruby gem which can be used to integrate with Rails applications

![](docs/UhuraSystemArchitecture_20190501c.gif)

The core of the Uhura system is a Ruby on Rails application, **Uhura Comm Server** in the image above, that provides REST API endpoints for managing and sending messages over email and SMS to Highlands **SSO user**s based on their user preferences. This piece holds all of the ActiveRecord models and manages interfacing with a database, API clients, and message processors, i.e, **Sendgrid** and **Clearstream**. 

Uhura also include a basic **Admin App** for viewing and administrating Uhura's data layer.

The **Uhura Client** (https://github.com/dailydrip/uhura-client), is a Ruby gem provides an API Client for integrating with the message processing system. 

UhuraExampleApp (https://github.com/dailydrip/uhura-example-app) is an example Rails **App**lication that uses the Uhura client gem.


## Getting Started

These instructions will get you up and running with Uhura on your local machine for development and testing purposes. 

## Prerequisites

- Git
- Ruby 2.6.3
- bundler 2.0.2
- C++ client API for PostgreSQL

### bundler 2.0.2
``` 
gem install bundler:2.0.2
```

### C++ client API for PostgreSQL
#### On Ubuntu
```
sudo apt-get install libpq-dev
```

### Postgres
If you want to install the PostgreSQL database locally for development purposes you can follow these steps. Replace "lex" with your username.
``` 
$ sudo apt update
$ sudo apt install postgresql postgresql-contrib
$ sudo -i -u postgres psql
postgres=# CREATE ROLE lex SUPERUSER;
```

Giving your user role the SUPERUSER attribute allows you to run Rails database manipulation commands and migrations, e.g., `bundle exec rake db:create`

## Environment Variables

Uhura's environment variables have been divided into two sections.

### Basic Configuration 

Settings that are core to the operation of Uhura: 

- Routing
- Basic Authentication
- Service Timeouts
- Postgres (Database) Access
- Testing
- Logging.

### 3rd Party Services

Environment variables used to integrate with 3rd party services:

- Github Access
- Sendgrid Access
- Clearstream Access
- Highlands SSO Access



Here's a sample .env file:
```
#-----------------------------------------------
#              Basic Configuration
#-----------------------------------------------

export PATH="$(pwd)/bin:$PATH"

export APP_NAME='uhura'
export API_VER_NO="$(cat "lib/$(basename ${APP_NAME})/version.rb" | grep VERSION | head -n 1 | awk '{print $3}' | tr -d "'" | cut -d '.' -f1)"
export API_VER="api/v${API_VER_NO}"
export APP_DOMAIN='localhost:3000'
export APP_PROTOCOL='http://'
export BASE_URI="${APP_PROTOCOL}${APP_DOMAIN}"
export API_ENDPOINT="${BASE_URI}/${API_VER}/"
export ADMIN_PATH='/admin'

# Basic Auth
export TOKEN_AUTH_USER='uhura'
export TOKEN_AUTH_PASSWORD='XXXXXXXXXXXXXXXX'

# Service Timeout
#export RACK_TIMEOUT_SERVICE_TIMEOUT=15
#export RACK_TIMEOUT_WAIT_TIMEOUT=30
#export RACK_TIMEOUT_WAIT_OVERTIME=60
#export RACK_TIMEOUT_SERVICE_PAST_WAIT=false

## Postgres Access
export PGUSER=$USER
export PGPASSWORD=""

# Postgres - Production
DATABASE_URL="postgres://myuser:mypass@localhost/somedatabase"

# Testing
export NUMBER_OF_SLOW_TESTS_TO_DISPLAY=2

# Logging
export UHURA_LOGGER='RAILS_LOGGER' # 'LOGDNA', 'RAILS_LOGGER'
export LOG_LEVEL='INFO'  # 'TRACE', 'DEBUG', 'INFO', 'WARN', 'ERROR', 'FATAL'
export LOG_ENDPOINT='https://logs.logdna.com/logs/ingest'

#-----------------------------------------------
#             3rd Party Services
#-----------------------------------------------

# Github Access
export GITHUB_KEY='XXXXXXXXXXXXXXXXXXXX'
export GITHUB_SECRET='XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
export GITHUB_TOKEN='XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'

# Sendgrid Access
export SENDGRID_API_KEY='SG.XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'

# Clearstream Access
export CLEARSTREAM_KEY='XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
export CLEARSTREAM_BASE_URL='https://api.getclearstream.com/v1'
export CLEARSTREAM_URL='http://localhost:3000/v1'
export CLEARSTREAM_DEFAULT_LIST_ID=99999

# Highlands SSO Access
export SSO_KEY='XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
export SSO_SECRET='XXXXXXXXXXXXXXXX'
export HIGHLANDS_AUTH_REDIRECT='http://localhost:3000'
export HIGHLANDS_AUTH_SUPPORT_EMAIL='name@example.com'
export HIGHLANDS_SSO_EMAIL='sso.name@example.com'
export HIGHLANDS_SSO_PASSWORD='XXXXXXXXXXXX'

# LogDNA
export LOGDNA_KEY='XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'

```

You can load those environment variables into your terminal's session by sourcing your project's .env file:
```
source .env
```

### Installation

#### 1. Install Uhura 
```
$ mkdir ~/Projects
$ cd ~/Projects
$ git clone https://github.com/dailydrip/uhura.git
$ cd uhura
$ bundle
```

#### 2. Run Uhura Server
```
$ source .env
$ bundle exec rails server
```

#### 3. Visit Admin Application

Go to `http://localhost:3000/admin` and you'll see Uhura's admin application.  

Login with your Highlands SSO credentials.


### Tests

We use `rubocop` for Ruby linting and `rspec` for running unit tests. You can run them individually with the following commands:
```
$ bundle exec rubocop
$ bundle exec rspec
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details