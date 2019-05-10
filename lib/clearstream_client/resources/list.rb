# frozen_string_literal: true

module ClearstreamClient
  class List < BaseResource
    validates :name, presence: true

    attr_accessor :id, :name

    def initialize(attributes = {})
      deserialize(attributes['list'])
    end

    # Method for @data (to convert ClearstreamClient::Messaage and ::List objects) to a hash of callable attributes
    def to_h
      methodize_attributes(:id, :name)
    end

    private

    def deserialize(json)
      self.id = json['id']
      self.name = json['name']
      self
    end
  end
end
