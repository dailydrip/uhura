# frozen_string_literal: true

desc 'Merge the source user into the target user'

task 'users:add-admin', %i[email username first_name last_name] => [:environment] do |_, args|
  email = args[:email]
  username = args[:username]
  first_name = args[:first_name]
  last_name = args[:last_name]

  if !email || !username || !first_name || !last_name
    puts 'ERROR: Expecting rake users:add-admin[email,username,first_name,last_name]'
    exit 1
  end

  User.create!(
    email: email,
    username: username,
    admin: true,
    superadmin: true,
    first_name: first_name,
    last_name: last_name
  )
  puts '', 'Admin Added!', ''
end
