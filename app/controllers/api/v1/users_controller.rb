class Api::V1::UsersController < Api::V1::BaseController
  before_action :set_user, only: [:show,:update, :destroy]

  include ActiveHashRelation

  def index
    # no role checking here, everybody can see everything
    users = User.all
    users = apply_filters(users, params)

    render(
      json: ActiveModel::ArraySerializer.new(
        users,
        each_serializer: Api::V1::UserSerializer,
        root: 'users',
      )
    )
  end

  def show
    user = User.find(params[:id])

    render(json: Api::V1::UserSerializer.new(user).to_json)
  end

  def update
    # we'll get update calls here for user records *only*.
    # Calls to update resume's and their related models wind up
    # at their own endpoints.
    # Only a record owner (role == user and current user eq given user id)
    # or an admin (role == admin) can update.
    if current_user.has_role?(:admin) or (current_user.has_role?(:user) and current_user.id == params[:id])
      if @user.update(user_params)
        render(json: Api::V1::UserSerializer.new(user).to_json)
      else
        render :json => { :errors => @user.errors.full_messages }
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:email)
  end

end
