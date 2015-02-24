class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_filter :ensure_signup_complete, only: [:new, :create, :update, :destroy]
  
  before_filter :verify_current_user
  
  def ensure_signup_complete
    # Ensure we don't go into an infinite loop
    return if action_name == 'finish_signup'

    # Redirect to the 'finish_signup' page if the user
    # email hasn't been verified yet
    if current_user && !current_user.email_verified?
      redirect_to finish_signup_path(current_user)
    end
  end
  
  # filter to register information about the current logged user
  def verify_current_user
    user = current_user
    @user_is_logged = true if user else false
    @user_is_fetching = @user_is_logged && user.is_fetching
  end
  
end
