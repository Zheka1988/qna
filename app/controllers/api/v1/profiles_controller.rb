class Api::V1::ProfilesController < Api::V1::BaseController
  def me
    @user = current_resource_owner
    render json: @user
  end

  def all
    @users = User.all.where.not(id: current_resource_owner.id)
    render json: @users
  end
end