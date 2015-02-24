class EventsController < ApplicationController
  def show
    @event = Event.find(params[:id])
  end
  
  def import
    
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
  
end
