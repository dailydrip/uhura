# Uhura


#### Environment Variables

To run this project, you'll need a handful of environment variables for the Highlands Auth gem, clearstream and sendgrid.

```sh
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

# Clearstream
export CLEARSTREAM_KEY='XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
export CLEARSTREAM_BASE_URL='https://api.getclearstream.com/v1'
export CLEARSTREAM_URL='http://localhost:3000/v1'
export CLEARSTREAM_DEFAULT_LIST_ID=99999

# Twitter Access
export TWITTER_ACCESS_TOKEN='XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
export TWITTER_ACCESS_TOKEN_SECRET='XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
export TWITTER_KEY='XXXXXXXXXXXXXXXXXXXXXXXXX'
export TWITTER_SECRET='XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'

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


### Tests

We use Rubocop for Ruby linting, rspec for unit tests. You can run them indivdually with the following commands:

* $ bundle exec rubocop
* $ bundle exec rspec
