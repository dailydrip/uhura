Dir.chdir "/home/lex/Clients/Concur/Projects/uhura"

printf 'Loading Rails...'
require './config/environment.rb'

lex = User.last
lex.preferences['email'] = true
lex.preferences['sms'] = true
#lex.valid?
lex.save!