require "administrate/base_dashboard"

class ManagerDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    api_keys: Field::HasMany,
    # message_vos: Field::HasMany,
    id: Field::Number,
    name: Field::String,
    public_token: Field::String,
    email: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :api_keys,
    # :message_vos,
    :id,
    :name,
    :public_token,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :api_keys,
    # :message_vos,
    :id,
    :name,
    :public_token,
    :email,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :api_keys,
    # :message_vos,
    :name,
    :public_token,
    :email,
  ].freeze

  # Overwrite this method to customize how managers are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(manager)
  #   "Manager ##{manager.id}"
  # end
end
