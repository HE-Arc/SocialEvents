class MainController < ApplicationController
  def index
    @users_top = User.get_users_with_contributions_counter(5)
    
    title = "and"
    categories = ["fun", "Détente"]
    cantons = ["Bern"]
    @events = Event.get_listing_events(title, categories, cantons)
    
    @categories = Event.get_categories()
    @cantons = EventLocation.get_cantons()
  end
end
