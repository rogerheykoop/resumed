require "spec_helper"

describe "API user data" , :type => :request do

  let!(:user) { FactoryGirl.create(:user) }
  let!(:otheruser) { FactoryGirl.create(:user) }

  it "should give users data" do
    get_with_auth "/api/v1/users/#{user.id}.json",user.email,"abcd1234ABCD"
    expect(last_response.status).to eql(200)
    expect(JSON.parse(last_response.body)["user"]["id"]).to eql(user.id)
    expect(JSON.parse(last_response.body)["user"]["email"]).to eql(user.email)
  end
  
  it "should give other users data" do
    get_with_auth "/api/v1/users/#{otheruser.id}.json",user.email,"abcd1234ABCD"
    expect(last_response.status).to eql(200)
    expect(JSON.parse(last_response.body)["user"]["id"]).to eql(user.id)
    expect(JSON.parse(last_response.body)["user"]["email"]).to eql(user.email)
  end


end 
