require "spec_helper"

describe "API authentication" , :type => :request do

  let!(:user) { FactoryGirl.create(:user) }

  it "shouldn't be successful to make an API request without authorisation" do
    get "/api/v1/users/1",:format =>:json
    expect(last_response.status).to eql(401)
    error = "HTTP Basic: Access denied.\n"
    expect(last_response.body).to  eql(error)
  end

  it "should be successful with authentication" do
    get_with_auth '/api/v1/users.json',user.email,"abcd1234ABCD"
    expect(last_response.status).to eql(200)
  end

end 
