# Load uhura's config, utils and version files
require "#{Rails.root}/lib/uhura"

# Load SendGrid
require 'sendgrid-ruby'
include SendGrid

log_info "#{'=' * 50}"
log_info "=> Starting #{Rails.application.class.parent_name} version #{Uhura::VERSION}"
log_info "=> Rails #{Rails.version} in #{Rails.env} environment"
log_info "=> API endpoint at #{ENV['API_ENDPOINT']}"
log_info "#{'=' * 50}"
log_info ''
