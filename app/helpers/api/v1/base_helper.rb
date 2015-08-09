module Api::V1::BaseHelper
  def http_authenticate
    authenticate_or_request_with_http_digest do |user_name, password|
      user_name == "foo" && password == "bar"
    end
    warden.custom_failure! if performed?
  end

end
