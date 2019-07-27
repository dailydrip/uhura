# frozen_string_literal: true

Dir.chdir '/home/lex/Clients/Concur/Projects/uhura'

printf 'Loading Rails...'
require './config/environment.rb'

id = '58034259'
email = 'charles@churchofthehighlands.com'

# include Concerns::HighlandsAuth::AccountConcerns
# charles = get_accounts_details_for(email)
# ap charles

#include HighlandsAuth
#charles = HighlandsAuth::SessionsController.find_user(email)

# charles = HighlandsAuth::User.find_by(email: email)

# include HighlandsAuth
# @controller = HighlandsAuth::SessionsController.new
# @controller.instance_variable_set('@email', email)
# @controller.instance_variable_set('@id', id)
# charles = @controller.send("find_user")
# ap charles

require '/home/lex/Clients/Concur/Projects/uhura/lib/highlands_client.rb'

def get_user(data)
  data = data[:highlands_data]
  response = HighlandsClient::MessageClient.new(data: data,
                                                resource: data[:resource]).get_user(data[:email])

  preferred_communications = response['data']['communications']['communication'].select{ |item| item['preferred'] == 'true' }
  mobile_communications = preferred_communications.select{ |item| item['communicationType']['name'] == 'Mobile'}
  email_communications = preferred_communications.select{ |item| item['communicationGeneralType'] == 'Email'}
  mobile_phones = mobile_communications.map{|item| item['communicationValue']}
  emails = email_communications.map{|item| item['communicationValue']}

  ap response
  if !err.nil?
    msg = 'GET highlands user Error'
    return ReturnVo.new(value: nil, error: return_error(msg, :unprocessable_entity))
  else
    preferred_communications = {
        communications: {
            mobile_phones: mobile_phones,
            emails: emails
        }
    }
    return ReturnVo.new(value: return_accepted(preferred_communications: preferred_communications), error: nil)
  end

end

ret = get_user({
             highlands_data: {
                 resource: 'search_by_email',
                 email: 'charles@churchofthehighlands.com',
             }
         })

ap ret