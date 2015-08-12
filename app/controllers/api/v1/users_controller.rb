class Api::V1::UsersController < Api::V1::BaseController
  before_action :set_user, only: [:show,:update, :destroy]
  load_and_authorize_resource

  include ActiveHashRelation

  def_param_group :user do
    param :email, String, :desc => "E-mail address", :required => false
    param :password, String, :desc => "Password", :required => false
    param :password_confirmation, String, :desc => "Password Confirmation", :required => false
    param :role, String, :desc => "Role name (admin only)", :required => false
  end

  api :GET, "/v1/users", "Get users"
  formats [:json]
  description <<-EOS
  == Get an array of users
  This will create an array of user objects. All roles have access.
    EOS
  def index
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

api :GET, "/v1/users/:id", "Get user by id"
formats [:json]
  def show
    if can? :read, User
      render(json: Api::V1::UserSerializer.new(@user).to_json)
    end
  end

  api :PUT, "/v1/users/:id", "Update user by id"
  formats [:json]
  description <<-EOS
  == Update a user record
  This will update a single user object and upon success return a complete user object, including all resume data. All roles have access.
  == Update the user's password
    Send identical data in password and password_confirmation. Otherwise the password will not change.
    == Roles
    The system has three roles. Admin, User and Guest. Admin can CRUD any record. User can read/index all records, update and delete their own records. Guest is read only.
    The default role is *user*. A default admin user can be created using the rake db:seed
    == Set the role
    If you are an admin you can set the role by passing the role variable. *It is ignored if you are not an admin*.
  EOS
  def update
    if can? :update, User
      if @user.update(user_params.except(:role))
        if current_user.has_role?(:admin) and !user_params[:role].nil?
          @user.remove_role :admin
          @user.remove_role :guest
          @user.remove_role :user
          @user.add_role(user_params[:role])
        end
        render(json: Api::V1::UserSerializer.new(@user).to_json)
      else
        render :json => { :errors => @user.errors.full_messages }
      end
    end
  end

  api :DELETE, "/v1/users/:id", "Deleta a user by id"
  formats [:json]
  description <<-EOS
    == Delete a user record
    This will delete the user's record including all sub-data.
    EOS
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
    params.require(:user).permit(:email,:password,:password_confirmation,:role)
  end

end
