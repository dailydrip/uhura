Dir.chdir "/home/lex/Clients/Concur/Projects/uhura"

printf 'Loading Rails...'
require './config/environment.rb'

sgv = SendgridMailVo.new()
sgv.from = "lex@smoothterminal.com"
sgv.template_id = "d-f986df533e514f978f4460bedca50db0"
sgv.to = "lex@smoothterminal.com"

puts sgv.valid?

sgv.dynamic_template_data = {
    "email_subject": "Picnic NOW!",
    "header":"test header",
    "text":"blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah",
    "c2a_button": "Sign me up!"
}

puts sgv.valid?

ap sgv

sgv = SendgridMailVo.new(
    from: "lex@smoothterminal.com",
    to:  "lex@smoothterminal.com",
    template_id: "d-f986df533e514f978f4460bedca50db0",
    dynamic_template_data: {
        "header":"test header",
        "text":"blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah",
        "c2a_button": "Sign me up!"
    }
)

puts sgv.valid?

x = sgv.get

ap sgv
