class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
    
  before_filter :verify_current_user
  
  # filter to register information about the current logged user
  def verify_current_user
    user = current_user
    @user_is_logged = true if user else false
    @user_is_fetching = @user_is_logged && user.is_fetching
  end
  
end
