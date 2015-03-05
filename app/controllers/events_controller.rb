require "koala"
require "openssl"
require "base64"

class EventsController < ApplicationController
  
  def show
    @event = Event.find(params[:id])
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
        
      # Insertion du lieu dans la base de données
      location = EventLocation.new(    
        :id_facebook  =>  f["id"].to_i,
        :name  =>  f["name"],
        :city  =>  f["location"]["city"],
        :street  =>  f["location"]["street"],
        :zip  =>  f["location"]["zip"],
        :canton  =>  "zgeg",
        :country  =>  f["location"]["country"],
        :latitude  =>  f["location"]["latitude"],
        :longitude  =>  f["location"]["longitude"],
        :category  =>  f["category"],
        :cover  =>  "zgeg",
        :likes  =>  f["likes"],
        :link  =>  f["link"],
        :phone  =>  f["phone"],
        :website  =>  f["website"])   
      
      location.save()
        
        
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
      
      location = EventLocation.select(:id).where(id_facebook: event_request["owner"]["id"]).take
      
      if not location.nil?
        # Insertion du lieu dans la base de données
        event_location = @graph.get_object(event_request["owner"]["id"])

        location = EventLocation.new(    
          :id_facebook  =>  event_location["id"].to_i,
          :name  =>  event_location["name"],
          :city  =>  event_location["location"]["city"],
          :street  =>  event_location["location"]["street"],
          :zip  =>  event_location["location"]["zip"],
          :canton  =>  "zgeg",
          :country  =>  event_location["location"]["country"],
          :latitude  =>  event_location["location"]["latitude"],
          :longitude  =>  event_location["location"]["longitude"],
          :category  =>  event_location["category"],
          :cover  =>  "zgeg",
          :likes  =>  event_location["likes"],
          :link  =>  event_location["link"],
          :phone  =>  event_location["phone"],
          :website  =>  event_location["website"])   

        location.save()
      end 
      
      cover_image = @graph.get_object(event_request["id"]+"/photos?fields=source")
        puts "--------------------------------------------------------------------"
        puts cover_image
        puts "--------------------------------------------------------------------"
      # Insertion des événements dans la base de données
      event = Event.new(
        :id_facebook => event_request["id"],
        :title => event_request["name"],
        :picture => cover_image["source"],
        :category => "",
        :description => event_request["description"],
        :start_time => event_request["start_time"],
        :end_time => event_request["end_time"],
        :user_id => current_user.id,
        :event_location_id => location.id)
      
      event.save()
      
    end
  end
end


