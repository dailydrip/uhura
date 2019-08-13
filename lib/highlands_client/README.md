![Highlands Logo](../../docs/uhura_messaging.png)



# Uhura's Highlands SSO Library

**This library allows you to quickly and easily access Highland SSO's user_preferences data via Ruby.**

This library can be made into a gem, but that was not necessary given its specific use case for Uhura.

This highlands_client library can be found in the lib directory of your [Uhura](https://github.com/dailydrip/uhura) project. 

## Prerequisites

- Ruby version 2.6.3
- Access to the Highlands SSO service

## Setup Environment Variables

Update the development environment with your Highlands SSO credentials for example:

```bash
# Highlands SSO Access
export SSO_KEY='deadbeefdeadbeefdeadbeefdeadbeefdeadbeef'
export SSO_SECRET='deadbeefdeadbeef'
export HIGHLANDS_AUTH_REDIRECT='http://localhost:3000'
export HIGHLANDS_AUTH_SUPPORT_EMAIL='support@example.com'
export HIGHLANDS_SSO_EMAIL='highlands-sso-user@example.com'
export HIGHLANDS_SSO_PASSWORD='SSO_USER_PASSWORD'
```
See [Uhura](https://github.com/dailydrip/uhura) project's [README.md](https://github.com/dailydrip/uhura/README.md) for details about environment variables and the .env file.

## Dependencies

- [Uhura](<https://github.com/dailydrip/uhura>)



# Usage Details

## user_preferences

The following code snippet from the *message_vo.rb* file shows where `highlands_data` is defined and passed to `Receiver.from_user_preferences`

### MessageVo Class

```ruby
    ret = Receiver.from_user_preferences(
      highlands_data: {
        resource: 'user_preferences',
        id: @receiver_sso_id
      }
    )
```

The following code snippet from the *receiver.rb* file shows where the `HighlandsClient::MessageClient` library's `get_receiver` method is called:

### Receiver Class

```ruby
class Receiver
# . . .
  def self.from_user_preferences(data)
    data = data[:highlands_data]
    response = HighlandsClient::MessageClient.new(
        data: data,
        resource:data[:resource]).get_receiver(data[:id])
```



## Under the Covers

### RESTful Call to Highlands SSO

Here's an example of a RESTful call to retrieve the specified Highlands SSO user_preferences data:

```ruby
curl -X GET \
  'https://sso.highlandsapp.com/api/v1/user_preferences?id=63501603' \
  -H 'Authorization: Token token=deadbeefdeadbeefdeadbeefdeadbeef' \
  -H 'Host: sso.highlandsapp.com'
```

### Response - Email & SMS

Here's an example response for a user (Bob Example) that prefers to receive both email and SMS messages:

```ruby
{
    "user_id": 63501603,
    "first_name": "Bob",
    "last_name": "Example",
    "email": "bob@exampl.com",
    "phone_number": "205-999-9999",
    "preferences": [
        {
            "email": "bob@exampl.com",
            "phone_number": "205-999-9999"
        }
    ]
}
```



### Response - Email

Here's an example for a user (Bob Example) that prefers to receive only email messages:

```ruby
{
    "user_id": 63501603,
    "first_name": "Bob",
    "last_name": "Example",
    "email": "bob@exampl.com",
    "phone_number": "205-999-9999",
    "preferences": [
        {
            "email": "bob@exampl.com"
        }
    ]
}
```



### Response - SMS

Here's an example for a user (Bob Example) that prefers to receive only SMS messages:

```ruby
{
    "user_id": 63501603,
    "first_name": "Bob",
    "last_name": "Example",
    "email": "bob@exampl.com",
    "phone_number": "205-999-9999",
    "preferences": [
        {
            "phone_number": "205-999-9999"
        }
    ]
}
```



# License

This project is licensed under the MIT License - See the [LICENSE](LICENSE.txt) file for details.