# frozen_string_literal: true

module HighlandsClient
  class List < BaseResource
    validates :name, presence: true

    attr_accessor :id, :name

    def initialize(attributes = {})
      deserialize(attributes['data'])
    end

    # Method for @data (to convert HighlandsClient::Messaage and ::List objects) to a hash of callable attributes
    def to_h
      methodize_attributes(:id, :lastName)
    end

    private

    def deserialize(json)
      self.id = json['id']
      self.name = json['lastName']
      self
    end
  end
end
