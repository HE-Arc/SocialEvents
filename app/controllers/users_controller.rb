class UsersController < ApplicationController

  before_action :require_connected
  
  # Show user profile if current user is logged in
  # GET /users/:id.:format
  def show
    @user = User.get_user_with_contribution_counter(params[:id])
    @is_my_profile = @user == current_user
    @events = Event.get_user_events(@user.id)
  end
  
  private
    def require_connected
      unless @user_is_logged
        redirect_to root_url, alert: "You must be logged in to browse user details."
      end
    end
  
end
