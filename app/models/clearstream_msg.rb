# frozen_string_literal: true

class ClearstreamMsg < ApplicationRecord
  has_many :clearstream_msg_events
end
