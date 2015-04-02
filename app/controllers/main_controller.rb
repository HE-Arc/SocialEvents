class MainController < ApplicationController
  def index
    @users_top = User.get_users_with_contributions_counter(5)
    #@events = Event.get_listing_events(nil, nil, nil, 5, 0, nil)  # No data fetch here, all is done by ajax call
    
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
    
    date = date != "all" ? DateTime.strptime(date, "%Y-%m-%d") : nil
    cantons_list = cantons != "all" ? cantons.split(',') : nil
    categories_list = categories != "all" ? categories.split(',') : nil
    title = title != "*" ? title : nil
    
    # todo
    if limit != nil
      limit = limit.to_i
    end
    if offset != nil
      offset = offset.to_i
    end
    
    @events = Event.get_listing_events(title, categories_list, cantons_list, limit, offset, date)
    
    render :json => @events
  end
end