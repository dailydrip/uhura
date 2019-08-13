![Uhura Messaging](../../docs/uhura_messaging.png)



# Uhura's Clearstream Library

**This library allows you to quickly and easily access Clearstream's API via Ruby.**

This library can be made into a gem, but that was not necessary given its specific use case for Uhura.

This clearstream_client library can be found in the lib directory of your [Uhura](https://github.com/dailydrip/uhura) project. 

## Prerequisites

- Ruby version 2.6.3
- Admin Access to the Clearstream service.



### Clearstream

Uhura uses Clearstream as it's external SMS processor.

Create an account at [https://app.getclearstream.com](https://app.getclearstream.com/) where you can:

- Get an [API key](https://app.getclearstream.com/settings/api) and assign it to the `CLEARSTREAM_KEY` environment variable
- Create [webhooks](https://app.getclearstream.com/settings/webhooks) to tell Uhura when Clearstream events occur
- View sent SMS statistics



## Setup Environment Variables

Update the development environment with your Clearstream credentials for example:

```bash
# Clearstream Access
export CLEARSTREAM_KEY='deadbeefdeadbeefdeadbeefdeadbeefdeadbeef'
export CLEARSTREAM_BASE_URL='https://api.getclearstream.com/v1'
export CLEARSTREAM_URL='http://localhost:3000/v1'
export CLEARSTREAM_DEFAULT_LIST_ID=99999
```
See [Uhura](https://github.com/dailydrip/uhura) project's [README.md](https://github.com/dailydrip/uhura/README.md) for details about environment variables and the .env file.

## Dependencies

- [Uhura](<https://github.com/dailydrip/uhura>)



# API Details

## send_message

The following code snippet from the *clearstream_handler.rb* file shows where the `ClearstreamClient::MessageClient` library's `send_message` method is called:

### Receiver Class

```ruby
  def self.send_msg(data)
    message_id = data[:clearstream_vo]['message_id']
    # Request Clearstream client to send message
    response = ClearstreamClient::MessageClient.new(data: data[:clearstream_vo],
                                                    resource: 'messages').send_message

```



## Under the Covers

### data[:clearstream_vo]

Here's how Uhura packages up the `clearstream_vo` data:

```ruby
{
  "resource": "messages",
  "message_id": 3,
  "mobile_number": "+12059999999",
  "message_header": "Leadership Team",
  "message_body": "Bring Drinks to the Picnic this Saturday",
  "subscribers": "+12059999999",
  "schedule": false,
  "send_to_fb": false,
  "send_to_tw": false
}
```

### Response - Success

Here's an example response for a user (Bob Example) when his mobile_number is not setup in Clearstream:

```ruby
    "clearstream_msg": {
        "value": {
            "status": 202,
            "data": {
                "clearstream_msg": "Asynchronously sent SMS: (Leadership Team:Picnic Saturday) from (Sample - App 1) to (7709999999)"
            },
            "error": null
        },
        "error": null
    }
```



### Response - Invalid Subscriber mobile_number

Here's an example response for a user (Bob Example) when his mobile_number is not setup in Clearstream:

```ruby
    "clearstream_msg": {
        "value": null,
        "error": {
            "status": 422,
            "data": null,
            "error": {
                "msg": "At least one of the supplied subscribers is invalid.",
                "action_required:": {
                    "error_from_clearstream": "At least one of the supplied subscribers is invalid.",
                    "assumed_meaning": "This receiver w/ mobile_number (2059999999) not registered in Clearstream",
                    "action": "Research whether receiver_sso_id (99999999) is valid."
                }
            }
        }
    }
```



# License

This project is licensed under the MIT License - See the [LICENSE](LICENSE.txt) file for details.