class Event < ActiveRecord::Base
  belongs_to :user
  belongs_to :event_location
  
  # Listing des événements publics selon différents critères de filtrage
  #    title        titre ou description de l'événement
  #    categories   catégories possibles
  #    cantons      cantons possibles
  #    limit        nombre d'événements
  #    offset       indice de début de récupération
  #    date         date à partir de laquelle on récupère les événements, si non spécifiée retourne tous les futurs événements
  def self.get_listing_events(title=nil, categories=nil, cantons=nil, limit=nil, offset=nil, date=nil)
    
    query = self.joins(:event_location).order(:start_time).order(:title)
                .where('is_published = true')

    if not date.nil?
      query = query.where("DATE(events.start_time) <= ? AND DATE(events.end_time) >= ?", date, date)
    else
      query = query.where("DATE(events.end_time) >= ?", DateTime.now.to_date)
    end
    
    if not title.nil?
      # ILIKE propre à Postgres
      query = query.where('events.title ILIKE ? OR events.description ILIKE ?', "%#{title}%", "%#{title}%")
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
    
    if not offset.nil?
      query = query.offset(offset)
    end
        
    query
  end
  
  # Listing des catégories d'événements
  def self.get_categories
    self.distinct.order(:category).pluck(:category)
  end
  
  # Purge les événements plus vieux que la date du jour
  def self.purge_events
    date = DateTime.now.to_date
    self.where("? > DATE(events.end_time)", date).destroy_all
  end

  # Récupération des événements visibles d'un utilisateur
  #     user_id      id de l'utilisateur spécifique
  #   limit, offse   limite et décalage pour pagination  
  def self.get_user_events_profil(user_id, limit=nil, offset=nil)
    query = self.joins(:event_location).order(:start_time).order(:title)
        .where("? <= DATE(events.end_time)", DateTime.now.to_date)
        .where(:is_published => true)
        .where("user_id = ?", user_id)
    
    if not limit.nil?
      query = query.limit(limit)
    end
    
    if not offset.nil?
      query = query.offset(offset)
    end
        
    query
  end
end
