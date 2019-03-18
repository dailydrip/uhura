# frozen_string_literal: true

require 'net/http'
require 'json'
require 'uri'

class SgEmailApi
  attr_accessor :id, :from_email, :to_email, :subject, :content, :response_status_code

  def initialize(attributes = {})
    @id         = attributes[:id].to_i
    @from_email = attributes[:from_email]
    @to_email   = attributes[:to_email]
    @subject    = attributes[:subject]
    @content    = attributes[:content]
    @response_status_code = attributes[:response_status_code]
  end

  def self.post
    post_data = Net::HTTP.post_form(URI.parse("#{ENV['API_ENDPOINT']}/sg_emails/"),
                                    from_email: 'lex.nospam@gmail.com',
                                    to_email: 'lex.sheehan@gmail.com',
                                    subject: 'A test from Postman',
                                    content: 'How r u?')

    return_success(post_data.to_s)
  end

  def self.get(id)
    new JSON.parse(Net::HTTP.get(endpoint('sg_emails', id)), symbolize_names: true)
  end

  private_class_method def self.endpoint(*path)
    URI.parse([ENV.fetch('API_ENDPOINT'), *path].join('/'))
  end

  private_class_method def self.read_fixture(*path)
    File.read [__dir__, '..', '..', '..', ENV['API_VER'], 'fixtures', *path].join('/')
  end
end
