# Uhura


#### Environment Variables

To run this project, you'll need a handful of environment variables for the Highlands Auth gem, clearstream and sendgrid.

```sh
export RAILS_MASTER_KEY=""
export TOKEN_AUTH_USER=""
export CLEARSTREAM_URL=""
export SSO_KEY=""
export SSO_SECRET=""
export HIGHLANDS_AUTH_REDIRECT=""
export HIGHLANDS_AUTH_SUPPORT_EMAIL=""
export HIGHLANDS_SSO_EMAIL=""
export HIGHLANDS_SSO_PASSWORD=""
export CLEARSTREAM_DEFAULT_LIST_ID=""
export TOKEN_AUTH_PASSWORD=""
export GITHUB_KEY=""
export GITHUB_SECRET=""
export GITHUB_TOKEN=""
export SENDGRID_API_KEY=""
export CLEARSTREAM_KEY=""
export CLEARSTREAM_BASE_URL=""
```


### Tests

We use Rubocop for Ruby linting, rspec for unit tests. You can run them indivdually with the following commands:

* $ bundle exec rubocop
* $ bundle exec rspec
