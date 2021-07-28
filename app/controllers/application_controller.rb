class ApplicationController < ActionController::Base
  before_action :gon_user, unless: :devise_controller?
  
  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { render nothing: true, status: :forbidden }
      format.js   { head :forbidden, alert: exception.message }
      format.html { redirect_to root_url, alert: exception.message }
    end
  end
  private
  
  def gon_user
    gon.user_id = current_user.id if current_user
  end
end
