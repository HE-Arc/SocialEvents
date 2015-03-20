require "koala"
require "openssl"
require "base64"

class ImportEventsTask
  
  class << self
    
    def import(user_id, token, latitude, longitude)
                  
      user = User.find(user_id)
      user.is_fetching = true
      user.save!
      
      self.fetch(user_id, token, latitude, longitude)

      user.is_fetching = false
      user.save!
      
    end
    handle_asynchronously :import
    
  end

  private
    
  def self.strposa(haystack, needle, offset=0)
    count = 0
    needle.each do |n|
      count = count + haystack.scan(n).count
    end
    puts count
    return count
  end
  
  def self.fetch(user_id, token, latitude, longitude)
    category_musique = ["Album", "Artist", "Arts/entertainment/nightlife", "Author", "Bar", "Club", "Concert tour", "Concert venue", "Music", "Music award","electro", "Music chart", "Music video", "Musical genre", "Musical instrument", "Musician/band", "musique", "music","dj", "musiques", "concert", "festival de musique", "MUSIC", "MUSIQUE", "Clubbing", "Dance-hall","funk","rock","jam", "Jam","compositeur","blues"]
    category_cinema = ["Actor/director", "Comedian", "Movie","Movie general", "Movie genre", "Movie theater", "Movies/music", "cinéma", "cinémas", "projection", "film", "films", "NIFFF", "CINEMA"]
    category_art = ["Arts/humanities website", "Dancer", "Museum/art gallery", "Society/culture website", "expositions","exposition","musée", "galerie"]
    category_spectacle = ["Attractions/things to do", "Event planning/event services", "spectacle", "spetacles", "représentation","Théâtre", "sketch", "sketches","sketche"]
    # **************************************************************
    # Authentification process
    # **************************************************************
    
    # Authentification à l'application Facebook
    @oauth = Koala::Facebook::OAuth.new("653919454735658","035ddda1f5dc692934d9f0abc345e4ef","/import/data")
    
    # Permission pour le graph search
    @oauth.url_for_oauth_code(:permissions => "publish_actions")
    
    # Autorisation pour le graph search
    @graph = Koala::Facebook::GraphAPI.new(token)

    # ******************************************************************
    # Get a list of bar using user GPS. I only get 40 bars at the moment
    # ******************************************************************
    
    # Affiche les événements à proximité de l'utilisateur
    eventlocation = @graph.get_object("search?q=&type=place&center=" + latitude + "," + longitude + "&distance=40000&limit=40")
    @events_locations = eventlocation
    
    # **************************************************************
    # Get event list for each location and store them in eventlist
    # **************************************************************
    eventlist = Array.new
    eventlocation.each do |f| 
      eventlist_request = @graph.get_object(f["id"]+"/events?since=now")
      if !eventlist_request.empty?
        eventlist_request.each do |f| 
            eventlist.push(f)
        end
      
      location = EventLocation.where(:id_facebook => f["id"]).first_or_initialize

      # Insertion du lieu dans la base de données
      location.update_attributes(
        :name  =>  f["name"],
        :city  =>  f["location"]["city"],
        :street  =>  f["location"]["street"],
        :zip  =>  f["location"]["zip"],
        :canton  =>  Localite.find_canton(f["location"]["zip"]),
        :country  =>  f["location"]["country"],
        :latitude  =>  f["location"]["latitude"],
        :longitude  =>  f["location"]["longitude"],
        :category  =>  f["category"],
        :likes  =>  f["likes"],
        :link  =>  f["link"],
        :phone  =>  f["phone"],
        :website  =>  f["website"]
        )   
      end 
    end
    
    # **************************************************
    # Get events details and store them in @events
    # **************************************************
    @events = Array.new
    
    # Get events details loop
    eventlist.each do |fe| 
      #puts "--------------------------------------------------------------------"
      #puts fe
      #puts "--------------------------------------------------------------------"

      event_request = @graph.get_object(fe["id"])
      @events = @events.push(event_request)
      
      location = EventLocation.select(:id).where(id_facebook: event_request["owner"]["id"])

      if not location.nil?
        # Insertion du lieu dans la base de données
        event_location = @graph.get_object(event_request["owner"]["id"])

        location = EventLocation.where(:id_facebook => event_location["id"]).first_or_initialize

        location.update_attributes(    
          :name  =>  event_location["name"],
          :city  =>  event_location["location"]["city"],
          :street  =>  event_location["location"]["street"],
          :zip  =>  event_location["location"]["zip"],
          :canton  =>  Localite.find_canton(event_location["location"]["zip"]),
          :country  =>  event_location["location"]["country"],
          :latitude  =>  event_location["location"]["latitude"],
          :longitude  =>  event_location["location"]["longitude"],
          :category  =>  event_location["category"],
          :likes  =>  event_location["likes"],
          :link  =>  event_location["link"],
          :phone  =>  event_location["phone"],
          :website  =>  event_location["website"]
          )   
      end 
      
      cover_image = @graph.get_object(event_request["id"]+"/photos?fields=source")
        #puts "--------------------------------------------------------------------"
        #puts cover_image[0]["source"]
        #puts location.id
        #puts "--------------------------------------------------------------------"
      
      event = Event.where(:id_facebook => event_request["id"]).first_or_initialize
      
      # Vérification si image n'est pas null
      image_cover = ""
      if cover_image[0]
        image_cover = cover_image[0]["source"]
      end
      
      
      # Si date de fin non spécifier, alors on ajoute 1 jour à la date de début
      endtime = event_request["end_time"]
      if not event_request["end_time"]
        endtime = DateTime.parse(event_request["start_time"])
        endtime += 1.days
      end
      
      #recherche dans la description
      count = strposa(event_request["description"], category_musique)
      temp = strposa(event_request["description"], category_cinema)
      eventCategory = "Musique"
      
      if count >= temp 
        eventCategory = "Musique"
      else
        count = temp
        eventCategory = "Cinéma"
      end
        
      temp2 = strposa(event_request["description"], category_art)
      if temp2 > count
        count = temp2
        eventCategory = "Musée / Exposition"
      end
      
      temp3 = strposa(event_request["description"], category_spectacle)
      if temp3 > count
        count = temp3
        eventCategory = "Spectacle / Théâtre"
      end  
      
      #puts "-------"
      #puts event_request["name"]
      #puts event_request["description"]
      #puts eventCategory
      #puts "-------"
      puts "1 événement ajouté"
      
      event.update_attributes(
        :title => event_request["name"],
        :picture => image_cover,
        :category => eventCategory,
        :description => event_request["description"],
        :start_time => event_request["start_time"],
        :end_time => endtime,
        :user_id => user_id,
        :event_location_id => location.id
      )
    end
  end
    
#   def self.fetch(token, latitude, longitude)
#     # **************************************************************
#     # Authentification process
#     # **************************************************************

#     # Authentification à l'application Facebook
#     @oauth = Koala::Facebook::OAuth.new("653919454735658","035ddda1f5dc692934d9f0abc345e4ef", "/import/test")

#     # Permission pour le graph search
#     @oauth.url_for_oauth_code(:permissions => "publish_actions")

#     # Autorisation pour le graph search
#     @graph = Koala::Facebook::GraphAPI.new(token)

#     # ******************************************************************
#     # Get a list of bar using user GPS. I only get 40 bars at the moment
#     # ******************************************************************

#     # Affiche les événements à proximité de l'utilisateur
#     eventlocation = @graph.get_object("search?q=bar&type=place&center=46.94,6.85&distance=40000&limit=40")
#     @events_locations = eventlocation

#     # **************************************************************
#     # Get event list for each location and store them in eventlist
#     # **************************************************************
#     eventlist = Array.new
#     eventlocation.each do |f| 
#       eventlist_request = @graph.get_object(f["id"]+"/events?since=now")
#       if !eventlist_request.empty?
#         eventlist_request.each do |f| 
#           eventlist.push(f)
#         end
#       end      
#     end

#     # **************************************************
#     # Get events details and store them in @events
#     # **************************************************
#     @events = Array.new

#     # Get events details loop
#     eventlist.each do |fe| 
#       puts "--------------------------------------------------------------------"
#       puts fe
#       puts "--------------------------------------------------------------------"

#       event_request = @graph.get_object(fe["id"])
#       @events = @events.push(event_request)
#     end

#     @events.each do |event|
#       e = Event.new
#       e.title = event["name"]
#       e.event_location_id = 1
#       e.save!
#     end
#   end
  
end
