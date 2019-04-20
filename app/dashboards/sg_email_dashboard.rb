require "administrate/base_dashboard"

class SgEmailDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    from_email: Field::String,
    to_email: Field::String,
    subject: Field::String,
    content: Field::Text,
    response_status_code: Field::String,
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
    :from_email,
    :to_email,
    :subject,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :from_email,
    :to_email,
    :subject,
    :content,
    :response_status_code,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :from_email,
    :to_email,
    :subject,
    :content,
    :response_status_code,
  ].freeze

  # Overwrite this method to customize how sg emails are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(sg_email)
  #   "SgEmail ##{sg_email.id}"
  # end
end
