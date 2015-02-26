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
    # Authentification à l'application Facebook
    @oauth = Koala::Facebook::OAuth.new("653919454735658","035ddda1f5dc692934d9f0abc345e4ef","/import/test")
    
    # Permission pour le graph search
    @oauth.url_for_oauth_code(:permissions => "publish_actions")
    
    # Autorisation pour le graph search
    @graph = Koala::Facebook::GraphAPI.new(session["devise.facebook_data"]["credentials"]["token"])

    # Affiche les événements à proximité de l'utilisateur
    feed = @graph.get_object("search?q=nearby&type=event")
    
    # Affichage
    feed.each {|f| puts f } # it's a subclass of Array
    render :json => feed

  end
end


