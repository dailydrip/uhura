require "administrate/base_dashboard"

class ClearstreamMsgDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    sent_to_clearstream: Field::DateTime,
    sms_json: Field::String.with_options(searchable: false),
    got_response_at: Field::DateTime,
    clearstream_response: Field::Text,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :sent_to_clearstream,
    :sms_json,
    :got_response_at,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :sent_to_clearstream,
    :sms_json,
    :got_response_at,
    :clearstream_response,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :sent_to_clearstream,
    :sms_json,
    :got_response_at,
    :clearstream_response,
  ].freeze

  # Overwrite this method to customize how clearstream msgs are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(clearstream_msg)
  #   "ClearstreamMsg ##{clearstream_msg.id}"
  # end
end
