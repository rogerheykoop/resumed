require "spec_helper"

describe "API user data" , :type => :request do

  let!(:user) { FactoryGirl.create(:user,:user) }
  let!(:guestuser) { FactoryGirl.create(:user,:guest) }
  let!(:adminuser) { FactoryGirl.create(:user,:admin) }

  it "should give user object data" do
    get_with_auth "/api/v1/users/#{user.id}.json",user.email,"abcd1234ABCD"
    expect(last_response.status).to eql(200)
    expect(JSON.parse(last_response.body)["user"]["id"]).to eql(user.id)
    expect(JSON.parse(last_response.body)["user"]["email"]).to eql(user.email)
  end

  it "should give other users data" do
    get_with_auth "/api/v1/users/#{guestuser.id}.json",user.email,"abcd1234ABCD"
    expect(last_response.status).to eql(200)
    expect(JSON.parse(last_response.body)["user"]["id"]).to eql(guestuser.id)
    expect(JSON.parse(last_response.body)["user"]["email"]).to eql(guestuser.email)
  end

  it "shouldn't let me change my own data as a guest" do
    patch_with_auth "/api/v1/users/#{guestuser.id}.json",{:user=>{:email=>"guestuser_1@example.com"}},guestuser.email,"abcd1234ABCD"
    expect(JSON.parse(last_response.body)).to eql({ "errors" => "Error: You are not allowed to do this." })
  end

  it "should let me change my own data as a user" do
    patch_with_auth "/api/v1/users/#{user.id}.json",{:user=>{:email=>"newemail@example.com"}},user.email,"abcd1234ABCD"
    expect(JSON.parse(last_response.body)["user"]["id"]).to eql(user.id)
    expect(JSON.parse(last_response.body)["user"]["email"]).to eql("newemail@example.com")
  end

  it "shouldn't let me change another users data as a user" do
    patch_with_auth "/api/v1/users/#{guestuser.id}.json",{:user=>{:email=>"anothernewemail@example.com"}},user.email,"abcd1234ABCD"
    expect(JSON.parse(last_response.body)).to eql({ "errors" => "Error: You are not allowed to do this." })
  end

  it "should let me change another users data as an admin" do
    patch_with_auth "/api/v1/users/#{guestuser.id}.json",{:user=>{:email=>"yetanothernewemail@example.com"}},adminuser.email,"abcd1234ABCD"
    expect(JSON.parse(last_response.body)["user"]["id"]).to eql(guestuser.id)
    expect(JSON.parse(last_response.body)["user"]["email"]).to eql("yetanothernewemail@example.com")
  end



end
