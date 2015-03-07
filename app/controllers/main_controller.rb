class MainController < ApplicationController
  def index
    @users_top = User.get_users_with_contributions_counter(5)
    
    title = "and"
    categories = ["fun", "Détente"]
    cantons = ["Bern"]
    #@events = Event.get_listing_events(title, categories, cantons)
    #TODO first load limit 10
    @events = Event.get_listing_events(nil, nil, nil, 10, 0, nil)
    
    @categories = Event.get_categories()
    @cantons = EventLocation.get_cantons()
    
    offset = rand(Event.count)
    @event_cover = Event.offset(offset).first
  end
  
  def load
    categories = params[:categories]
    cantons = params[:cantons]
    date = params[:date]
    title = params[:title]
    limit = params[:limit]
    offset = params[:offset]
    
    cantons_list = cantons != "all" ? cantons.split(',') : nil
    categories_list = categories != "all" ? categories.split(',') : nil
    title = title != "*" ? title : nil
    
    # todo
    limit = nil
    offset = nil
    
    @events = Event.get_listing_events(title, categories_list, cantons_list, limit, offset, date)
    
    render :json => @events
  end
end
