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

def get_receiver(data)
  data = data[:highlands_data]
  response = HighlandsClient::MessageClient.new(data: data,
                                                resource: data[:resource]).get_user_preferences(data[:id])
  ap response
  if response.nil?
    return ReturnVo.new(value: nil, error: return_error('get_user_preferences not found', :unprocessable_entity))
  else
    user = response
    user['preferences'] = convert_preferences(response['preferences'])
    user['mobile_number'] = response['phone_number']
    user.delete('phone_number')
    user['receiver_sso_id'] = response['user_id']
    user.delete('user_id')
    receiver = Receiver.new(user)
    return ReturnVo.new(value: nil, error: return_error('Invalid user', :unprocessable_entity)) unless receiver.valid?

    return ReturnVo.new(value: return_accepted(receiver), error: nil)
  end
end

# FROM
#     "preferences": [
#       {
#         "email": "user.name@example.com",
#         "phone_number": "999-999-9999"
#       }
#     ]
# TO  {email: false, sms: false}
def convert_preferences(preferences)
  if preferences[0].blank?
    return {email: false, sms: false}
  else
    {
        email: !preferences[0][:email].blank?,
        sms: !preferences[0][:phone_number].blank?
    }
  end
end

ret = get_receiver({
             highlands_data: {
                 resource: 'user_preferences',
                 id: '63501603',
             }
         })

ap ret