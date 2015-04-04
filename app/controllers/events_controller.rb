class EventsController < ApplicationController
    
  # Show specified event
  def show 
    @event = Event.find(params[:id])
    @user = User.find(@event.user_id)
    @events_location = EventLocation.find(@event.event_location_id)
  end
  
  # Delete specified event of current user
  def destroy
    @event = Event.find(params[:id])
    
    if @event.user_id == current_user.id
      #do not only hide the event, effectively delete it from DB!
      #@event.is_published = false
      #@event.save
      @event.destroy
      redirect_to :back, notice: "The event has been deleted."
      
    else
      redirect_to :back, alert: "You cannot delete someone's events like that, what are you thinking?"
    end
  end
  
  # Delete all events from current user
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


