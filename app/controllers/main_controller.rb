class MainController < ApplicationController
  def index
    @users_top = User.get_users_with_contributions_counter(10)
  end
end
