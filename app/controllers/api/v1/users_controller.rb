class Api::V1::UsersController < Api::V1::BaseController
  before_action :set_user, only: [:show,:update, :destroy]
  load_and_authorize_resource

  include ActiveHashRelation

  api!
  formats :json
  description <<-EOS
    == Get all users
    This will create an array of user objects. All roles have access.
  EOS
  def index
    # no role checking here, everybody can see everything
    if can? :read, User
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
  end

  api!
  def show
    if can? :read, User
      render(json: Api::V1::UserSerializer.new(@user).to_json)
    end
  end

  api!
  def update
    if can? :update, User
      if @user.update(user_params)
        render(json: Api::V1::UserSerializer.new(@user).to_json)
      else
        render :json => { :errors => @user.errors.full_messages }
      end
    end
  end

  api!
  def destroy
    if can? :destroy, User
      if @user.destroy
        render :json => { :succes => "user destroyed" }
      else
        render :json => { :errors => @user.errors.full_messages }
      end
    end
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email)
  end

end
