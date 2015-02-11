class EventLocation < ActiveRecord::Base
  has_many :events, dependent: :destroy
end
