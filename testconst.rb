Dir.chdir "/home/lex/Clients/Concur/Projects/uhura"

printf 'Loading Rails...'
require './config/environment.rb'

if !!defined? CLI_SOURCE_TYPE_ID
  puts 'here'
end

CLI_SOURCE_TYPE_ID = 1
INFO_EVENT_TYPE_ID = 2

if !!defined? CLI_SOURCE_TYPE_ID && CLI_SOURCE_TYPE_ID.to_i > 0 && !!defined? INFO_EVENT_TYPE_ID
  puts 'here'
end