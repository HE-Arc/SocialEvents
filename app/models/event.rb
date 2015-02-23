class Event < ActiveRecord::Base
  belongs_to :user
  belongs_to :event_location
  
  def self.get_listing_events(title=nil, categories=nil, cantons=nil)
    query = self.joins(:event_location).order(:start_time).order(:title)
    
    if not title.nil?
      query = query.where('events.title LIKE ? OR events.description LIKE ?', "%#{title}%", "%#{title}%")
    end
    
    if not categories.nil?
      query = query.where('events.category IN (?)', categories)
    end
    
    if not cantons.nil?
      query = query.where('event_locations.canton IN (?)', cantons)
    end
    
    query
  end
  
end
