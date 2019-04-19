# Load uhura's config, utils and version files
require "#{Rails.root}/lib/uhura"

# Load SendGrid
require 'sendgrid-ruby'
include SendGrid
