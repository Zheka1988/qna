class Api::V1::ProfilesController < Api::V1::BaseController  
  # authorize_resource
  before_action :load_user, only: [:me, :index]

  def me 
    authorize! :me, @user

    render json: @user
  end

  def index
    authorize! :index, @user
    
    @users = User.all.where.not(id: current_resource_owner.id)
    render json: @users
  end

  private
  def load_user
    @user = current_resource_owner
  end
end