class Api::V1::BaseController < ApplicationController
  protect_from_forgery with: :null_session

  before_filter :authenticate_user

  before_action :no_session

  def no_session
    request.session_options[:skip] = true
  end

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from CanCan::AccessDenied do |exception|
      render :json => { :errors => "Error: You are not allowed to do this.",:status=>403 }
  end

  def not_found
    return api_error(status: 404, errors: 'Not found')
  end

  def authenticate_user
    authenticate_or_request_with_http_basic do |username,password|
      resource = User.find_by_email(username)
      if resource.valid_password?(password)
        sign_in :user, resource
      end
    end
  end


end
