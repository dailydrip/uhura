Dir.chdir "/home/lex/Clients/Concur/Projects/uhura"

printf 'Loading Rails...'
require './config/environment.rb'


require 'sendgrid-ruby'
include SendGrid

data = JSON.parse('{
   "from":{
      "email":"lex@smoothterminal.com"
   },
   "personalizations":[
      {
         "to":[
            {
               "email":"lex@smoothterminal.com"
            }
         ],
         "dynamic_template_data":{
            "header":"test header",
            "text":"blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah",
            "c2a_button": "Sign me up!"
         }
      }
   ],
   "template_id":"d-f986df533e514f978f4460bedca50db0"
}')
sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
response = sg.client.mail._("send").post(request_body: data)
puts response.status_code
puts response.body
puts response.headers