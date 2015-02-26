class Event < ActiveRecord::Base
  belongs_to :user
  belongs_to :event_location
  
  # Listing des événements selon différents critères de filtrage
  #    title        titre ou description de l'événement
  #    categories   catégories possibles
  #    cantons      cantons possibles
  #    limit        nombre d'événements
  #    offset       indice de début de récupération
  #    date         date à partir de laquelle on récupère les événements
  def self.get_listing_events(title=nil, categories=nil, cantons=nil, limit=nil, from=nil, date=nil)
    if date.nil?
      date = DateTime.now.to_date
    end
    
    query = self.joins(:event_location).order(:start_time).order(:title).where("? <= events.end_time", date)

    if not title.nil?
      query = query.where('events.title LIKE ? OR events.description LIKE ?', "%#{title}%", "%#{title}%")
    end
    
    if not categories.nil?
      query = query.where('events.category IN (?)', categories)
    end
    
    if not cantons.nil?
      query = query.where('event_locations.canton IN (?)', cantons)
    end
    
    if not limit.nil?
      query = query.limit(limit)
    end
    
    if not from.nil?
      query = query.offset(offset)
    end
        
    query
  end
  
  # Listing des catégories d'événements
  def self.get_categories
    self.distinct.pluck(:category)
  end
  
  # Purge les événements plus vieux que la date du jour
  def self.purge_events
    date = DateTime.now.to_date
    self.where("'2020-02-02' > events.end_time", date).destroy_all
  end
  
end
