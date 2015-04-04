class EventsController < ApplicationController
  
  helper_method :javascript_include_view_js
    
  # Generate JS tags for GMaps API
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
  
  # Show specified event
  def show 
    @event = Event.find(params[:id])
    @user = User.find(@event.user_id)
    @events_location = EventLocation.find(@event.event_location_id)
  end
  
  # "Delete" specified event
  def destroy
    # the destroy hide the event (is_published ~> false), it will be deleted later when it is finished (end date < today)
    @event = Event.find(params[:id])
    
    if @event.user_id == current_user.id
      @event.is_published = false
      @event.save
      redirect_to :back, notice: "The event has been deleted."
      
    else
      redirect_to :back, alert: "You cannot delete someone's events like that, what are you thinking?"
    end
  end
  
  # "Delete" all events from user ~> hide them in fact
  def destroy_all
    unless current_user.nil?
      current_user.events.destroy_all
      redirect_to :back, notice: "All events have been deleted."
    else
      redirect_to :back, alert: "Deleting an event is restricted to logged-in users."
    end
  end
  
  # Launch an import task for retrieve asynchronously events from Facebook Graph API
  def import_data
    user = current_user
    key_word = params[:key_word]
    
    will_import = user && !user.is_fetching
    
    # start import
    if will_import
      ImportEventsTask.import(user.id, session["devise.facebook_data"]["credentials"]["token"],params[:latitude],params[:longitude], root_url, key_word)      
    end
    
    render :json => will_import
  end
  
  # allows to verify with JSON answer if the current_user is fetching (importing) from Facebook
  def import_verify
    user = current_user    
    is_fetching = user ? user.is_fetching : false
      
    render :json => is_fetching
  end 
end


