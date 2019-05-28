# frozen_string_literal: true

Dir.chdir '/home/lex/Clients/Concur/Projects/uhura'

printf 'Loading Rails...'
require './config/environment.rb'

log_puts '1. Seeding Managers (Apps)'
