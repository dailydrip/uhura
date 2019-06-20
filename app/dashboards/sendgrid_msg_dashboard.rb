# frozen_string_literal: true

require 'administrate/base_dashboard'

class SendgridMsgDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::String.with_options(searchable: false),
    sent_to_sendgrid: Field::DateTime,
    mail_and_response: Field::String.with_options(searchable: false),
    got_response_at: Field::DateTime,
    sendgrid_response: Field::Text,
    read_by_user_at: Field::DateTime,
    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    id
    sent_to_sendgrid
    mail_and_response
    got_response_at
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    sent_to_sendgrid
    mail_and_response
    got_response_at
    sendgrid_response
    read_by_user_at
    created_at
    updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    sent_to_sendgrid
    mail_and_response
    got_response_at
    sendgrid_response
    read_by_user_at
  ].freeze

  # Overwrite this method to customize how sendgrid msgs are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(sendgrid_msg)
  #   "SendgridMsg ##{sendgrid_msg.id}"
  # end
end
