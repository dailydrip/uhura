# frozen_string_literal: true

module ClearstreamClient
  class Message < BaseResource
    validates :message_header, presence: true
    validates :message_body, presence: true
    validates :schedule, inclusion: [true, false]
    validates :send_to_fb, inclusion: [true, false]
    validates :send_to_tw, inclusion: [true, false]

    attr_accessor :id, :message_header, :message_body, :lists, :subscribers,
                  :schedule, :datetime, :timezone, :send_to_fb, :send_to_tw

    def initialize(attributes = {})
      deserialize(attributes['message'])
    end

    def to_h
      methodize_attributes(:id, :message_header, :message_body, :lists, :subscribers,
                           :schedule, :datetime, :timezone, :send_to_fb, :send_to_tw)
    end

    private

    def deserialize(json)
      self.id = json['id']
      self.message_header = json['message_header']
      self.message_body = json['message_body']
      self.lists = json['lists']
      self.subscribers = json['subscribers']
      self.schedule = json['schedule']
      self.datetime = json['datetime']
      self.timezone = json['timezone']
      self.send_to_fb = json['send_to_fb']
      self.send_to_tw = json['send_to_tw']
      self
    end
  end
end