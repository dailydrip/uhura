class Ulog < ApplicationRecord
  belongs_to :source
  belongs_to :event_type
end
