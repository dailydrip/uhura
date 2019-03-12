# Uhura

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

To be able to see the admin and the app in staging environment, you must have `ADMIN_NAME` and `ADMIN_PASSWORD` as environment variables.

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

## Staging

The application uses BASIC AUTH when in `staging`. We use the same password and username for the admin.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
