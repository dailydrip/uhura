Dir.chdir "/home/lex/Clients/Concur/Projects/uhura"

printf 'Loading Rails...'
require './config/environment.rb'

csv = ClearstreamSmsVo.new()
csv.receiver_email = 'lex@smoothterminal.com'
csv.message_header = 'Roll Deal'
csv.message_body = 'Come in now for 60% off all rolls!'

ap csv

csv.validate!

puts csv.valid?

ap csv.get()

