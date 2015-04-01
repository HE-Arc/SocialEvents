class EventsController < ApplicationController
  
  helper_method :javascript_include_view_js
  
  def javascript_include_view_js
    include = ''
    
    files = ["base.js", "base/base.js", "objects/base_builder.js", "objects/builder.js", "objects/handler.js", "objects/null_clusterer.js",
            "google/objects/common.js", "google/builders/bound.js", "google/builders/circle.js", "google/builders/clusterer.js",
            "google/builders/kml.js", "google/builders/map.js", "google/builders/marker.js", "google/builders/polygon.js",
            "google/builders/polyline.js", "google/objects/bound.js", "google/objects/circle.js", "google/objects/clusterer.js",
            "google/objects/kml.js", "google/objects/map.js", "google/objects/marker.js", "google/objects/polygon.js",
            "google/objects/polyline.js", "google/primitives.js", "google.js"]
    
    files.each do |f|
      include += '<script data-turbolinks-track="true" src="' + root_url + 'assets/gmaps/' + f + '?body=1" type="text/javascript"></script>'
    end
   
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
      ImportEventsTask.import(user.id, session["devise.facebook_data"]["credentials"]["token"],params[:latitude],params[:longitude], root_url)      
    end
    
    render :json => will_import
  end
    
  def import_verify
    user = current_user    
    is_fetching = user ? user.is_fetching : false
      
    render :json => is_fetching
  end 
end


