require "koala"
require "openssl"
require "base64"
require "erb"

class ImportEventsTask
    
  class << self
    
    # Entry point for asynchronous fetching
    # user_id    user_id which is fetching
    # token      facebook token
    # latitude, longitude  current user coordinates
    # root      url to root of the website
    def import(user_id, token, latitude, longitude, root, key_word)
                  
      user = User.find(user_id)
      user.is_fetching = true
      user.save!
      
      self.fetch(user_id, token, latitude, longitude, root, key_word)

      user.is_fetching = false
      user.save!
      
    end
    handle_asynchronously :import
    
  end

  private
    
  def self.strposa(haystack, needle, offset=0)
    count = 0
    unless haystack.nil?
      needle.each do |n|
        count = count + haystack.scan(n).count
      end
    end
    return count
  end
  
  # Doing the asynchronous fetching to FB through Graph API
  def self.fetch(user_id, token, latitude, longitude, root, key_word)
    category_musique = ["Album", "Artist", "Arts/entertainment/nightlife", "Author", "Bar", "Club", "Concert tour", "Concert venue", "Music", "Music award","electro", "Music chart", "Music video", "Musical genre", "Musical instrument", "Musician/band", "musique", "music","dj", "musiques", "concert", "festival de musique", "MUSIC", "MUSIQUE", "Clubbing", "Dance-hall","funk","rock","jam", "Jam","compositeur","blues"]
    category_cinema = ["Actor/director", "Comedian", "Movie","Movie general", "Movie genre", "Movie theater", "Movies/music", "cinéma", "cinémas", "projection", "film", "films", "NIFFF", "CINEMA"]
    category_art = ["Arts/humanities website", "Dancer", "Museum/art gallery", "Society/culture website", "expositions","exposition","musée", "galerie"]
    category_spectacle = ["Attractions/things to do", "Event planning/event services", "spectacle", "spetacles", "représentation","Théâtre", "sketch", "sketches","sketche"]
    # **************************************************************
    # Authentification process
    # **************************************************************
    
    # Authentification à l'application Facebook
    @oauth = Koala::Facebook::OAuth.new("653875894740014","f9ebc691eea51e52d648f1e5c4b36f35", "/")
    
    # Permission pour le graph search
    @oauth.url_for_oauth_code(:permissions => "publish_actions")
    
    # Autorisation pour le graph search
    @graph = Koala::Facebook::GraphAPI.new(token)

    # ******************************************************************
    # Get a list of bar using user GPS. I only get 40 bars at the moment
    # ******************************************************************
    
    # Affiche les événements à proximité de l'utilisateur
    eventlocation = @graph.get_object("search?q="+ ERB::Util.url_encode(key_word)+"&type=place&center=" + ERB::Util.url_encode(latitude) + "," + ERB::Util.url_encode(longitude) + "&distance=40000&limit=80")
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
        :id_facebook => f["id"],
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

      begin
        event_request = @graph.get_object(fe["id"])
        @events = @events.push(event_request)
      
        location = EventLocation.select(:id).where(id_facebook: event_request["owner"]["id"])

        if not location.nil?
          # Insertion du lieu dans la base de données
          event_location = @graph.get_object(event_request["owner"]["id"])
          
          # Note: can generate exception if nil

          unless event_location["location"].nil?
            location = EventLocation.where(:id_facebook => event_location["id"]).first_or_initialize

            location.update_attributes(    
              :id_facebook => event_location["id"],
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
        end 
      
        cover_image = @graph.get_object(event_request["id"]+"/photos?fields=source")
          #puts "--------------------------------------------------------------------"
          #puts cover_image[0]["source"]
          #puts location.id
          #puts "--------------------------------------------------------------------"

        event = Event.where(:id_facebook => event_request["id"]).first_or_initialize

        # Si date de fin non spécifier, alors on ajoute 1 jour à la date de début
        starttime = DateTime.parse(event_request["start_time"])
        #endtime = DateTime.parse(event_request["end_time"])
        if not event_request["end_time"]
          endtime = DateTime.parse(event_request["start_time"])
          endtime += 1.days
        else
          endtime = DateTime.parse(event_request["end_time"])
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
      
        # Vérification si image n'est pas null
        image_cover = ""
        if cover_image[0]
          image_cover = cover_image[0]["source"]
        else
          case eventCategory
          when "Cinéma"
            image_cover = root + 'images/cinema%d.jpg' % [rand(1..6)]
          when "Musée / Exposition"
            image_cover = root + 'images/art%d.jpg' % [rand(1..4)]
          when "Spectacle / Théâtre"
            image_cover = root + 'images/music%d.jpg' % [rand(1..9)]
          else
            image_cover = root + 'images/music%d.jpg' % [rand(1..9)]
          end
        end

        #puts "-------"
        #puts event_request["name"]
        #puts event_request["description"]
        #puts eventCategory
        #puts "-------"
        puts "1 événement ajouté"

        event.update_attributes(
          :id_facebook => event_request["id"],
          :title => event_request["name"],
          :picture => image_cover,
          :category => eventCategory,
          :description => event_request["description"] ? event_request["description"] : "",
          :start_time => starttime,
          :end_time => endtime,
          :user_id => user_id,
          :event_location_id => location.id
        )
      rescue Exception
        # oops
        puts "Import fetching exception"
        puts $!, $@
        Delayed::Worker.logger.debug("Import fetching exception")
        Delayed::Worker.logger.debug($!)
        Delayed::Worker.logger.debug($@)
      end
    end
  end
end