require "spec_helper"

describe "API" , :type => :request do

  describe "API user data" , :type => :request do

    let!(:user) { FactoryGirl.create(:user,:user) }
    let!(:guestuser) { FactoryGirl.create(:user,:guest) }
    let!(:adminuser) { FactoryGirl.create(:user,:admin) }

    it "should give user object data" do
      get_with_auth "/api/v1/users/#{user.id}.json",user.email,"abcd1234ABCD"
      expect(last_response.status).to eql(200)
      it_should_have_the_same_user_id_as(user)
      it_should_have_the_same_email_as(user.email)
    end

    it "should give other users data" do
      get_with_auth "/api/v1/users/#{guestuser.id}.json",user.email,"abcd1234ABCD"
      expect(last_response.status).to eql(200)
      it_should_have_the_same_user_id_as(guestuser)
      it_should_have_the_same_email_as(guestuser.email)

      # check to see if the resume id's in the objects have the same ID's
      expect(JSON.parse(last_response.body)["user"]["resumes"].map{|obj| obj["id"]}).to eql(guestuser.resumes.map{|obj| obj["id"]})
    end

    it "shouldn't let me change my own data as a guest" do
      patch_with_auth "/api/v1/users/#{guestuser.id}.json",{:user=>{:email=>"guestuser_1@example.com"}},guestuser.email,"abcd1234ABCD"
      it_should_disallow_this
    end

    it "should let me change my own data as a user" do
      patch_with_auth "/api/v1/users/#{user.id}.json",{:user=>{:email=>"newemail@example.com"}},user.email,"abcd1234ABCD"
      it_should_have_the_same_user_id_as(user)
      it_should_have_the_same_email_as("newemail@example.com")
    end

    it "shouldn't let me change another users data as a user" do
      patch_with_auth "/api/v1/users/#{guestuser.id}.json",{:user=>{:email=>"anothernewemail@example.com"}},user.email,"abcd1234ABCD"
      it_should_disallow_this
    end

    it "should let me change another users data as an admin" do
      patch_with_auth "/api/v1/users/#{guestuser.id}.json",{:user=>{:email=>"yetanothernewemail@example.com"}},adminuser.email,"abcd1234ABCD"
      it_should_have_the_same_user_id_as(guestuser)
      it_should_have_the_same_email_as("yetanothernewemail@example.com")
    end

  end
  describe "API edit of resumes" , :type => :request do
    let!(:user) { FactoryGirl.create(:user,:user) }
    let!(:guestuser) { FactoryGirl.create(:user,:guest) }
    let!(:adminuser) { FactoryGirl.create(:user,:admin) }
    it "should let me change my own resume name" do
      patch_with_auth "/api/v1/users/#{user.id}/resumes/#{user.resumes.first.id.to_s}.json",{:resume=>{:name=>"new resume name"}},user.email,"abcd1234ABCD"
      expect(JSON.parse(last_response.body)["resume"]["name"]).to eql("new resume name")
    end
    it "should let me create a new resume" do
      post_with_auth "/api/v1/users/#{user.id}/resumes.json",{:resume=>{:name=>"another new resume name"}},user.email,"abcd1234ABCD"
      expect(JSON.parse(last_response.body)["resume"]["name"]).to eql("another new resume name")
    end
    it "should let me destroy my own resume" do
      delete_with_auth "/api/v1/users/#{user.id}/resumes/#{user.resumes.last.id.to_s}.json",user.email,"abcd1234ABCD"
      expect(JSON.parse(last_response.body)).to eql({ "succes" => "resume destroyed"})
    end
  end
end
