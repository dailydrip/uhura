# frozen_string_literal: true

require 'cuba'
require 'awesome_print'

# Define routes, read response from fixture
Cuba.define do
  def read_fixture(*path)
    File.read [__dir__, "v#{ENV['API_VER_NO']}", 'fixtures', *path].join('/')
  end

  on get do
    on "#{ENV['API_VER']}/posts/:id" do |id|
      res.write read_fixture('posts', id)
    end

    on "#{ENV['API_VER']}/sg_emails/:id" do |id|
      res.write read_fixture('sg_emails', id)
    end
  end

  on post do
    on "#{ENV['API_VER']}/sg_emails/" do
      # POST /api/v1/sg_emails, from_email, to_email, subject, content
      on param('from_email'), param('to_email'), param('subject'), param('content') do |from_email, to_email, subject, content|
        json = "{\"status\": \"200\", \"data\": {\"from_email\": \"#{from_email}\", \"to_email\": \"#{to_email}\", \"subject\": \"#{subject}\", \"content\": \"#{content}\"}, \"message\": null}"
        res.write json
      end
    end
  end
end

# Run server if this file is executed on the command line
Rack::Handler::WEBrick.run(Cuba) if $PROGRAM_NAME == __FILE__
