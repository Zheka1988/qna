class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    sign_in_through_provider 
  end

  def facebook
    sign_in_through_provider 
  end

  def sign_in_through_provider
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: request.env['omniauth.auth'][:provider]) if is_navigational_format?
    else
      # redirect_to new_user_registration_url
      redirect_to root_path, alert: 'Something went wrong'
    end 
  end
end