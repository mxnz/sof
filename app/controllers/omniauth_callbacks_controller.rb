class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  around_action :all

  def facebook
  end

  def twitter
  end

  private
    def all
      auth = request.env['omniauth.auth']
      @user = User.from_omniauth(auth)
      if @user.persisted?
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: auth.provider.capitalize) if is_navigational_format?
      else
        session[:identity_id] = @user.identities.first.id
        redirect_to new_user_registration_url
      end
    end

end
