# frozen_string_literal: true

require 'administrate/base_dashboard'

class SendgridMsgEventDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    sendgrid_msg: Field::BelongsTo,
    id: Field::Number,
    status: Field::String,
    event: Field::String.with_options(searchable: false),
    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    sendgrid_msg
    id
    status
    event
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    sendgrid_msg
    id
    status
    event
    created_at
    updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    sendgrid_msg
    status
    event
  ].freeze

  # Overwrite this method to customize how sendgrid msg events are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(sendgrid_msg_event)
  #   "SendgridMsgEvent ##{sendgrid_msg_event.id}"
  # end
end
