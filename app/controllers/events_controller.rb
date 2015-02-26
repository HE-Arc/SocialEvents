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
      user.is_fetching = true
      user.save
      
      Thread.new {
        user_th = user
        sleep(10)
        user_th.is_fetching = false
        user_th.save
      }
      
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
      end      
    end
    
    # **************************************************
    # Get events details and store them in @events
    # **************************************************
    @events = Array.new
    
    # Get events details loop
    eventlist.each do |fe| 
      puts "--------------------------------------------------------------------"
      puts fe
      puts "--------------------------------------------------------------------"

      event_request = @graph.get_object(fe["id"])
      @events = @events.push(event_request)
    end
  end
end


