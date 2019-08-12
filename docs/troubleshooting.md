# Uhura Troubleshooting Guide

This document contains information that may help you troubleshoot issues you may encounter while installing, configuring and/or running Uhura.

## Missing Environment Variables

The **envied** gem ensures that the environment variables you specify in Envfile exist.

If  you have not sourced your .env file in your development environment and attempt to start the Rails Console you may encounter the following:

```
$ bundle exec rails console
DEPRECATION WARNING: Default values will be removed in the next minor-release of ENVied (i.e. > v0.9). For more info see https://gitlab.com/envied/envied/tree/0-9-releases#defaults. (called from block in load at /home/lex/Clients/Concur/Projects/uhura/Envfile:4)
Traceback (most recent call last):
	14: from bin/rails:4:in `<main>'
	13: from bin/rails:4:in `require'
	12: from /home/lex/.rbenv/versions/2.6.3/lib/ruby/gems/2.6.0/gems/railties-6.0.0.rc2/lib/rails/commands.rb:18:in `<top (required)>'
	11: from /home/lex/.rbenv/versions/2.6.3/lib/ruby/gems/2.6.0/gems/railties-6.0.0.rc2/lib/rails/command.rb:46:in `invoke'
	10: from /home/lex/.rbenv/versions/2.6.3/lib/ruby/gems/2.6.0/gems/railties-6.0.0.rc2/lib/rails/command/base.rb:65:in `perform'
	 9: from /home/lex/.rbenv/versions/2.6.3/lib/ruby/gems/2.6.0/gems/thor-0.20.3/lib/thor.rb:387:in `dispatch'
	 8: from /home/lex/.rbenv/versions/2.6.3/lib/ruby/gems/2.6.0/gems/thor-0.20.3/lib/thor/invocation.rb:126:in `invoke_command'
	 7: from /home/lex/.rbenv/versions/2.6.3/lib/ruby/gems/2.6.0/gems/thor-0.20.3/lib/thor/command.rb:27:in `run'
	 6: from /home/lex/.rbenv/versions/2.6.3/lib/ruby/gems/2.6.0/gems/railties-6.0.0.rc2/lib/rails/commands/console/console_command.rb:101:in `perform'
	 5: from /home/lex/.rbenv/versions/2.6.3/lib/ruby/gems/2.6.0/gems/railties-6.0.0.rc2/lib/rails/command/actions.rb:14:in `require_application_and_environment!'
	 4: from /home/lex/.rbenv/versions/2.6.3/lib/ruby/gems/2.6.0/gems/railties-6.0.0.rc2/lib/rails/command/actions.rb:22:in `require_application!'
	 3: from /home/lex/.rbenv/versions/2.6.3/lib/ruby/gems/2.6.0/gems/railties-6.0.0.rc2/lib/rails/command/actions.rb:22:in `require'
	 2: from /home/lex/Clients/Concur/Projects/uhura/config/application.rb:8:in `<top (required)>'
	 1: from /home/lex/.rbenv/versions/2.6.3/lib/ruby/gems/2.6.0/gems/envied-0.9.3/lib/envied.rb:18:in `require'
/home/lex/.rbenv/versions/2.6.3/lib/ruby/gems/2.6.0/gems/envied-0.9.3/lib/envied.rb:34:in `error_on_missing_variables!': The following environment variables should be set: TOKEN_AUTH_USER, TOKEN_AUTH_PASSWORD, SENDGRID_API_KEY, CLEARSTREAM_KEY, CLEARSTREAM_URL, CLEARSTREAM_DEFAULT_LIST_ID, SSO_KEY, SSO_SECRET, HIGHLANDS_AUTH_REDIRECT, HIGHLANDS_AUTH_SUPPORT_EMAIL, HIGHLANDS_SSO_EMAIL, HIGHLANDS_SSO_PASSWORD. (RuntimeError)
```

### Solution

Export the missing environment variables and try again:

```
$ . .env
$ bundle exec rails console
DEPRECATION WARNING: Default values will be removed in the next minor-release of ENVied (i.e. > v0.9). For more info see https://gitlab.com/envied/envied/tree/0-9-releases#defaults. (called from block in load at /home/lex/Projects/uhura/Envfile:4)
**************************************************
⛔️ WARNING: Sidekiq testing API enabled, but this is not the test environment.  Your jobs will not go to Redis.
**************************************************
Loading development environment (Rails 6.0.0.rc2)
irb(main):001:0> 



```



## Git Error when running bundle

```
$ bundle
Fetching gem metadata from https://rubygems.org/........
Fetching https://github.com/thoughtbot/administrate.git
Fetching git@github.com:highlands/highlands_auth.git
The authenticity of host 'github.com (192.30.253.113)' can't be established.
RSA key fingerprint is SHA256:nThbg6kXUpJWGl7E1IGOCspRomTxdCARLviKw6E5SY8.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added 'github.com,192.30.253.113' (RSA) to the list of known hosts.
git@github.com: Permission denied (publickey).
fatal: Could not read from remote repository.

Please make sure you have the correct access rights
and the repository exists.

Retrying `git clone 'git@github.com:highlands/highlands_auth.git' "/home/lex/.rbenv/versions/2.6.3/lib/ruby/gems/2.6.0/cache/bundler/git/highlands_auth-b2baa94dcc2151f79eb37dcb7119a6903f48e3da" --bare --no-hardlinks --quiet` due to error (2/4): Bundler::Source::Git::GitCommandError Git error: command `git clone 'git@github.com:highlands/highlands_auth.git' "/home/lex/.rbenv/versions/2.6.3/lib/ruby/gems/2.6.0/cache/bundler/git/highlands_auth-b2baa94dcc2151f79eb37dcb7119a6903f48e3da" --bare --no-hardlinks --quiet` in directory /home/lex/Projects/uhura has failed.
git@github.com: Permission denied (publickey).
fatal: Could not read from remote repository.

Please make sure you have the correct access rights
and the repository exists.

Retrying `git clone 'git@github.com:highlands/highlands_auth.git' "/home/lex/.rbenv/versions/2.6.3/lib/ruby/gems/2.6.0/cache/bundler/git/highlands_auth-b2baa94dcc2151f79eb37dcb7119a6903f48e3da" --bare --no-hardlinks --quiet` due to error (3/4): Bundler::Source::Git::GitCommandError Git error: command `git clone 'git@github.com:highlands/highlands_auth.git' "/home/lex/.rbenv/versions/2.6.3/lib/ruby/gems/2.6.0/cache/bundler/git/highlands_auth-b2baa94dcc2151f79eb37dcb7119a6903f48e3da" --bare --no-hardlinks --quiet` in directory /home/lex/Projects/uhura has failed.
git@github.com: Permission denied (publickey).
fatal: Could not read from remote repository.

Please make sure you have the correct access rights
and the repository exists.

Retrying `git clone 'git@github.com:highlands/highlands_auth.git' "/home/lex/.rbenv/versions/2.6.3/lib/ruby/gems/2.6.0/cache/bundler/git/highlands_auth-b2baa94dcc2151f79eb37dcb7119a6903f48e3da" --bare --no-hardlinks --quiet` due to error (4/4): Bundler::Source::Git::GitCommandError Git error: command `git clone 'git@github.com:highlands/highlands_auth.git' "/home/lex/.rbenv/versions/2.6.3/lib/ruby/gems/2.6.0/cache/bundler/git/highlands_auth-b2baa94dcc2151f79eb37dcb7119a6903f48e3da" --bare --no-hardlinks --quiet` in directory /home/lex/Projects/uhura has failed.
git@github.com: Permission denied (publickey).
fatal: Could not read from remote repository.

Please make sure you have the correct access rights
and the repository exists.

Git error: command `git clone 'git@github.com:highlands/highlands_auth.git'
"/home/lex/.rbenv/versions/2.6.3/lib/ruby/gems/2.6.0/cache/bundler/git/highlands_auth-b2baa94dcc2151f79eb37dcb7119a6903f48e3da" --bare
--no-hardlinks --quiet` in directory /home/lex/Projects/uhura has failed.

```



If you get " Permission denied (publickey)" then you likely need to setup your github public key.  

Try running `ssh -T git@github.com` Do you get a `Permission denied (publickey)`error?

```
$ ssh -T git@github.com
Warning: Permanently added the RSA host key for IP address '140.82.114.4' to the list of known hosts.
git@github.com: Permission denied (publickey).
```



### Solution

Follow the [Connecting to GitHub with SSH](https://help.github.com/en/articles/connecting-to-github-with-ssh) instructions.



## "environment variables" Errors when Running rspec

```
$ bundle exec rspec
rspec pid: 697
DEPRECATION WARNING: Default values will be removed in the next minor-release of ENVied (i.e. > v0.9). For more info see https://gitlab.com/envied/envied/tree/0-9-releases#defaults. (called from block in load at /home/lex/Projects/uhura/Envfile:4)

An error occurred while loading ./spec/controllers/api/v1/message_status_controller_spec.rb.
Failure/Error: require File.expand_path('../config/environment', __dir__)

RuntimeError:
  The following environment variables should be set: TOKEN_AUTH_USER, TOKEN_AUTH_PASSWORD, SENDGRID_API_KEY, CLEARSTREAM_KEY, CLEARSTREAM_URL, CLEARSTREAM_DEFAULT_LIST_ID, SSO_KEY, SSO_SECRET, HIGHLANDS_AUTH_REDIRECT, HIGHLANDS_AUTH_SUPPORT_EMAIL, HIGHLANDS_SSO_EMAIL, HIGHLANDS_SSO_PASSWORD.
# ./config/application.rb:8:in `<top (required)>'
# ./config/environment.rb:2:in `require_relative'
# ./config/environment.rb:2:in `<top (required)>'
# ./spec/rails_helper.rb:5:in `require'
# ./spec/rails_helper.rb:5:in `<top (required)>'
# ./spec/controllers/api/v1/message_status_controller_spec.rb:3:in `require'
# ./spec/controllers/api/v1/message_status_controller_spec.rb:3:in `<top (required)>'
DEPRECATION WARNING: Default values will be removed in the next minor-release of ENVied (i.e. > v0.9). For more info see https://gitlab.com/envied/envied/tree/0-9-releases#defaults. (called from block in load at /home/lex/Projects/uhura/Envfile:4)


```



### Solution

Export the missing environment variables and try again:

```
$ . .env
$ bundle exec rspec
rspec pid: 5239
DEPRECATION WARNING: Default values will be removed in the next minor-release of ENVied (i.e. > v0.9). For more info see https://gitlab.com/envied/envied/tree/0-9-releases#defaults. (called from block in load at /home/lex/Projects/uhura/Envfile:4)
........................................................................................................................................................

Finished in 1 minute 23.58 seconds (files took 4.59 seconds to load)
152 examples, 0 failures

Exiting LogDNA logger: Logging remaining messages
```



## Hanging RSpec processes

When an rspec process is already running (did not terminate) rspec will hang shortly after starting. Run this alias to kill any running rspec processes and start rspec (without it hanging).

### Solution

Run `be-rspec` alias rather than `bundle exec rspec`.  

```
alias be-rspec='ps -ef | grep -v grep|grep "\/rspec" | while read line; do pid2kill="$(echo \"$line\" | awk '\''{print $2}'\'')"; if [ "$pid2kill" != "" ]; then kill -9 $pid2kill; fi; done; bundle exec rspec'
```

Run `print-rspec-stacktrace` to see the stacktrace when it appears rspec is hung.

```
# Print rspec stacktrace. Assumes trap 'USR1' has been created in spec_helper.rb.
alias print-rspec-stacktrace='kill -USR1 "$(cat /tmp/rspec.pid)"'
```



## Missing Postgres Library

If you chose not to install the Postgres database in the server instance where you install Uhura, then you'll need to install the C++ client API for PostgreSQL.

You'll see something similar to this if you try to run bundle on your workstation without either PostgreSQL server or it's client library installed:

```
$ bundle
. . .
Fetching pg 1.1.4
Installing pg 1.1.4 with native extensions
Gem::Ext::BuildError: ERROR: Failed to build gem native extension.

current directory: /home/lex/.rbenv/versions/2.6.3/lib/ruby/gems/2.6.0/gems/pg-1.1.4/ext
/home/lex/.rbenv/versions/2.6.3/bin/ruby -I /home/lex/.rbenv/versions/2.6.3/lib/ruby/2.6.0 -r ./siteconf20190808-2903-twpmvy.rb extconf.rb
checking for pg_config... no
No pg_config... trying anyway. If building fails, please try again with
 --with-pg-config=/path/to/pg_config
checking for libpq-fe.h... no
Can't find the 'libpq-fe.h header
*** extconf.rb failed ***
Could not create Makefile due to some reason, probably lack of necessary
libraries and/or headers.  Check the mkmf.log file for more details.  You may
need configuration options.
```

### Solution

Here's how you could install the PostgreSQL client library on an Ubuntu server:

```
sudo apt-get install libpq-dev
```



## This Api Key does not exist

If you happen to do that and get a message like the following, you can lookup the Authorization Bearer and public_token values using ActiveRecord queries:

```
uhura> Manager.find_by(name: 'Sample - App 1').public_token
"deadbeef00deadbeef01"

uhura> Manager.find_by(name: 'Sample - App 1').api_keys.map { |i| i.auth_token }
[
    [0] "beef0beef1beef2beef3"
]

```



### Failed Request
```
curl -X POST \
  http://localhost:3000/api/v1/messages \
  -H 'Accept: */*' \
  -H 'Authorization: Bearer dead0dead1dead2dead3' \
  -H 'Cache-Control: no-cache' \
  -H 'Content-Type: application/json' \
  -H 'X-Team-ID: 1' \
  -d '{
	"public_token": "deadbeef00deadbeef01",
    "receiver_sso_id": "63501603",
    "email_subject": "Picnic Saturday",
    "email_message": {
	  "header": "Dragon Rage",
	  "section1": "imagine you are writing an email. you are in front of the computer. you are operating the computer, clicking a mouse and typing on a keyboard, but the message will be sent to a human over the internet. so you are working before the computer, but with a human behind the computer.",
	  "button": "Count me in!"
	},
    "template_id": "d-05d33214e6994b01b577602036bfa9f5",
    "sms_message": "Bring Drinks to the Picnic this Saturday"
}'
```

### Response
```
{"error":"This Api Key does not exist."}
```



### Solution

The auth_token gets reset when you run `bundle exec rake db:drop`

You can either run `bundle exec db:drop db:create db:migrate db:seed`to generate a new one, which will be displayed in the console, see below:



```
$  bundle exec rake db:drop db:create db:migrate db:seed
. . .
1. Seeding Managers (Apps)
2. Seeding ApiKeys
3. Seeding Teams
4. Seeding Templates
5. Seeding Users
6. Seeding MsgTarget
Seeding Done!
public_token: deadbeef00deadbeef01
Authorization Bearer token: beef0beef1beef2beef3

```



### Successful Request

```
curl -X POST \
  http://localhost:3000/api/v1/messages \
  -H 'Accept: */*' \
  -H 'Authorization: Bearer beef0beef1beef2beef3' \
  -H 'Cache-Control: no-cache' \
  -H 'Content-Type: application/json' \
  -H 'X-Team-ID: 1' \
  -d '{
	"public_token": "deadbeef00deadbeef01",
    "receiver_sso_id": "63501603",
    "email_subject": "Picnic Saturday",
    "email_message": {
	  "header": "Dragon Rage",
	  "section1": "imagine you are writing an email. you are in front of the computer. you are operating the computer, clicking a mouse and typing on a keyboard, but the message will be sent to a human over the internet. so you are working before the computer, but with a human behind the computer.",
	  "button": "Count me in!"
	},
    "template_id": "d-05d33214e6994b01b577602036bfa9f5",
    "sms_message": "Bring Drinks to the Picnic this Saturday"
}'
```

### Response

Note that Uhura's message response encapsulates two message service provider responses (one from Sendgrid and the other from Clearstream).

```
{
    "sendgrid_msg": {
        "value": {
            "status": 202,
            "data": {
                "sendgrid_msg": "Asynchronously sent email: (Leadership Team:Picnic Saturday) from (Sample - App 1) to (charles.jarrett@live.com <Charles Jarrett>)"
            },
            "error": null
        },
        "error": null
    },
    "clearstream_msg": {
        "value": null,
        "error": {
            "status": 422,
            "data": null,
            "error": {
                "msg": "At least one of the supplied subscribers is invalid.",
                "action_required:": {
                    "error_from_clearstream": "At least one of the supplied subscribers is invalid.",
                    "assumed_meaning": "This receiver w/ mobile_number (2056132729) not registered in Clearstream",
                    "action": "Research whether receiver_sso_id (63501603) is valid."
                }
            }
        }
    }
}
```

NOTE: The response above shows that the email was sent successfully, but the SMS message failed.



