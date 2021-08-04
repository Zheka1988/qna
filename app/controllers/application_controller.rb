class ApplicationController < ActionController::Base
  before_action :gon_user, unless: :devise_controller?
  
  def self.renderer_with_signed_in_user(user)
    ActionController::Renderer::RACK_KEY_TRANSLATION['warden'] ||= 'warden'
    proxy = Warden::Proxy.new({}, Warden::Manager.new({})).tap do |i|
      i.set_user(user, scope: :user, store: false, run_callbacks: false)
    end
    renderer.new('warden' => proxy)
  end

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden }
      format.js   { head :forbidden, alert: exception.message }
      format.html { redirect_to root_url, alert: exception.message }
    end
  end

  check_authorization unless: :devise_controller?
 
  private
  def gon_user
    gon.user_id = current_user.id if current_user
  end
end
