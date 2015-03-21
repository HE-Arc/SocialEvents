class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def self.provides_callback_for(provider)
    class_eval %Q{
      def #{provider}
        @user = User.find_for_oauth(env["omniauth.auth"], current_user)

        if @user.persisted?
          sign_in_and_redirect @user, event: :authentication
          session["devise.#{provider}_data"] = env["omniauth.auth"]
          set_flash_message(:notice, :success, kind: "#{provider}".capitalize) if is_navigational_format?

        else
          redirect_to root_url, alert: "An error occured when trying to connect with #{provider}, please try again."
        end
      end
    }
  end

  [:facebook].each do |provider|
    provides_callback_for provider
  end

  def after_sign_in_path_for(resource)
    super resource
  end
end
