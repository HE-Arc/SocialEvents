class EventLocation < ActiveRecord::Base
  has_many :events, dependent: :destroy
  
  # Listing des cantons existants
  def self.get_cantons
    self.distinct.pluck(:canton)
  end
  
end
