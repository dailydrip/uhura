![Uhura Messaging](images/uhura_messaging.png)



# Uhura Admin Guide

This guide contains screenshots of Uhura's admin application.



First, navigate to where you started the Uhura Messaging Server:

![](images/admin_screenshots/admin-0-home-page-link.png)



Next, click the *admin application* link.  

The default page for Uhura's admin application is the Managers page.

A manager represents the application that manages this Uhura installation.

In our example, Sample - App 1 is this Uhura instance's managing application.

![](images/admin_screenshots/admin-1-managers.png)

When the Uhura Client  application, e.g., *Sample - App 1*, sends requests to the Uhura Messaging Server for processing, it passes it's Public Token, e.g., `42c50c442ee3ca01378e` to identify itself.

![](images/curl-post-message-public_token.png)



![](images/admin_screenshots/admin-2-manager-edit.png)

![](images/admin_screenshots/admin-3-api_keys.png)

![](images/admin_screenshots/admin-4-api_key-edit.png)

![](images/admin_screenshots/admin-5-clearstream_msgs.png)

Please gnore the `{"error"=>"undefined method `receiver_sso_id' for :to_s:Symbol"}` error messages you see here.  They appear only for the few developers, in their development environment, when they happen to be running RubyMine in debug mode.![](images/admin_screenshots/admin-6-clearstream_msgs-last.png)

![](images/admin_screenshots/admin-7-clearstream_msg.png)

In case you're wondering, "Why aren't there any Clearstream Msg Events below?"  The answer is, "Because Clearstream waits 30 minutes before processing webhook events."  See the bottom of this guide for a screenshot of what this page looks like after 30 minutes has transpired.

![](images/admin_screenshots/admin-8-clearstream_msg_events-empty.png)

![](images/admin_screenshots/admin-9-messages.png)

![](images/admin_screenshots/admin-10-message-edit.png)

![](images/admin_screenshots/admin-11-message-edit-sendgrid_msg.png)

![](images/admin_screenshots/admin-12-message-edit-clearstream_msg.png)

![](images/admin_screenshots/admin-13-message-edit-manager.png)

![](images/admin_screenshots/admin-14-message-edit-receiver.png)

![](images/admin_screenshots/admin-15-message-edit-team.png)

![](images/admin_screenshots/admin-16-message-edit-template.png)

![](images/admin_screenshots/admin-17-sendgrid_msgs.png)

![](images/admin_screenshots/admin-18-sendgrid_msg-edit.png)

![](images/admin_screenshots/admin-19-sendgrid_msg_events.png)

![](images/admin_screenshots/admin-20-teams.png)

![](images/admin_screenshots/admin-21-team-edit.png)

![](images/admin_screenshots/admin-22-templates.png)

![](images/admin_screenshots/admin-23-template-edit.png)

![](images/admin_screenshots/admin-24-receivers.png)

![](images/admin_screenshots/admin-25-receiver-edit.png)

![](images/admin_screenshots/admin-26-users.png)

![](images/admin_screenshots/admin-27-user-edit.png)

## Delayed Clearstream Webhook Execution

After waiting 30 minutes, we try the Clearstream Msg Events page again and see that the Clearstream web hook has executed and updated this SMS message's status to `SENT`

![](images/admin_screenshots/admin-28-clearstream_msg_events-arrived.png)

![](images/admin_screenshots/admin-29-clearstream_msg_event-edit.png)


# License

This project is licensed under the MIT License - See the [LICENSE](LICENSE.txt) file for details.