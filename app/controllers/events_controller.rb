require "koala"
require "openssl"
require "base64"

class EventsController < ApplicationController
  
  helper_method :javascript_include_view_js
  
  def javascript_include_view_js
    include = ''
   
    include += '<script data-turbolinks-track="true" src="/assets/gmaps/base.js?body=1" type="text/javascript"></script>'
    include += '<script data-turbolinks-track="true" src="/assets/gmaps/base/base.js?body=1" type="text/javascript"></script>'
    include += '<script data-turbolinks-track="true" src="/assets/gmaps/objects/base_builder.js?body=1" type="text/javascript"></script>'
    include += '<script data-turbolinks-track="true" src="/assets/gmaps/objects/builder.js?body=1" type="text/javascript"></script>'
    include += '<script data-turbolinks-track="true" src="/assets/gmaps/objects/handler.js?body=1" type="text/javascript"></script>'
    include += '<script data-turbolinks-track="true" src="/assets/gmaps/objects/null_clusterer.js?body=1" type="text/javascript"></script>'
    include += '<script data-turbolinks-track="true" src="/assets/gmaps/google/objects/common.js?body=1" type="text/javascript"></script>'
    include += '<script data-turbolinks-track="true" src="/assets/gmaps/google/builders/bound.js?body=1" type="text/javascript"></script>'
    include += '<script data-turbolinks-track="true" src="/assets/gmaps/google/builders/circle.js?body=1" type="text/javascript"></script>'
    include += '<script data-turbolinks-track="true" src="/assets/gmaps/google/builders/clusterer.js?body=1" type="text/javascript"></script>'
    include += '<script data-turbolinks-track="true" src="/assets/gmaps/google/builders/kml.js?body=1" type="text/javascript"></script>'
    include += '<script data-turbolinks-track="true" src="/assets/gmaps/google/builders/map.js?body=1" type="text/javascript"></script>'
    include += '<script data-turbolinks-track="true" src="/assets/gmaps/google/builders/marker.js?body=1" type="text/javascript"></script>'
    include += '<script data-turbolinks-track="true" src="/assets/gmaps/google/builders/polygon.js?body=1" type="text/javascript"></script>'
    include += '<script data-turbolinks-track="true" src="/assets/gmaps/google/builders/polyline.js?body=1" type="text/javascript"></script>'
    include += '<script data-turbolinks-track="true" src="/assets/gmaps/google/objects/bound.js?body=1" type="text/javascript"></script>'
    include += '<script data-turbolinks-track="true" src="/assets/gmaps/google/objects/circle.js?body=1" type="text/javascript"></script>'
    include += '<script data-turbolinks-track="true" src="/assets/gmaps/google/objects/clusterer.js?body=1" type="text/javascript"></script>'
    include += '<script data-turbolinks-track="true" src="/assets/gmaps/google/objects/kml.js?body=1" type="text/javascript"></script>'
    include += '<script data-turbolinks-track="true" src="/assets/gmaps/google/objects/map.js?body=1" type="text/javascript"></script>'
    include += '<script data-turbolinks-track="true" src="/assets/gmaps/google/objects/marker.js?body=1" type="text/javascript"></script>'
    include += '<script data-turbolinks-track="true" src="/assets/gmaps/google/objects/polygon.js?body=1" type="text/javascript"></script>'
    include += '<script data-turbolinks-track="true" src="/assets/gmaps/google/objects/polyline.js?body=1" type="text/javascript"></script>'
    include += '<script data-turbolinks-track="true" src="/assets/gmaps/google/primitives.js?body=1" type="text/javascript"></script>'
    include += '<script data-turbolinks-track="true" src="/assets/gmaps/google.js?body=1" type="text/javascript"></script>'

    return include
  end
  
  def show
    
    @event = Event.find(params[:id])
    @user = User.find(@event.user_id)
    @events_location = EventLocation.find(@event.event_location_id)
  end
  
  def destroy
    # la destruction masque l'événement, il sera supprimé plus tard automatiquement lorsque sa date sera dépassée
    @event = Event.find(params[:id])
    
    if @event.user_id == current_user.id
      @event.is_published = false
      @event.save
      redirect_to :back, notice: "The event has been deleted"
      
    else
      redirect_to :back, alert: "You cannot delete someone's events like that, what are you thinking?"
    end
  end
  
  def import_data
    user = current_user
    
    will_import = user && !user.is_fetching
        
    if will_import
      ImportEventsTask.import(user.id, session["devise.facebook_data"]["credentials"]["token"])      
    end
    
    render :json => will_import
  end
  
  def import_verify
    user = current_user
    
    p "verify"
    
    is_fetching = user ? user.is_fetching : false
      
    render :json => is_fetching
  end
  
  # GRAPH API
  def test
    
    # **************************************************************
    # Authentification process
    # **************************************************************
    
    # Authentification à l'application Facebook
    @oauth = Koala::Facebook::OAuth.new("653919454735658","035ddda1f5dc692934d9f0abc345e4ef","/import/test")
    
    # Permission pour le graph search
    @oauth.url_for_oauth_code(:permissions => "publish_actions")
    
    # Autorisation pour le graph search
    @graph = Koala::Facebook::GraphAPI.new(session["devise.facebook_data"]["credentials"]["token"])

    # ******************************************************************
    # Get a list of bar using user GPS. I only get 40 bars at the moment
    # ******************************************************************
    
    # Affiche les événements à proximité de l'utilisateur
    eventlocation = @graph.get_object("search?q=bar&type=place&center=46.94,6.85&distance=40000&limit=40")
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
        :cover  =>  "zgeg",
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
          :cover  =>  "zgeg",
          :likes  =>  event_location["likes"],
          :link  =>  event_location["link"],
          :phone  =>  event_location["phone"],
          :website  =>  event_location["website"]
          )   
      end 
      
      cover_image = @graph.get_object(event_request["id"]+"/photos?fields=source")
        puts "--------------------------------------------------------------------"
        #puts cover_image[0]["source"]
        #puts location.id
        puts "--------------------------------------------------------------------"
      
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
      
      event.update_attributes(
        :title => event_request["name"],
        :picture => image_cover,
        :category => "",
        :description => event_request["description"],
        :start_time => event_request["start_time"],
        :end_time => endtime,
        :user_id => current_user.id,
        :event_location_id => location.id
      )
    end
  end
end


