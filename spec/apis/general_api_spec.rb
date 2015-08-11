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

    it "should let me change a users role as an admin" do
      patch_with_auth "/api/v1/users/#{guestuser.id}.json",{:user=>{:role=>"user"}},adminuser.email,"abcd1234ABCD"
      it_should_have_role(:user)
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


    it "should let me change a resume name as an admin" do
      patch_with_auth "/api/v1/users/#{user.id}/resumes/#{user.resumes.first.id.to_s}.json",{:resume=>{:name=>"new resume name"}},adminuser.email,"abcd1234ABCD"
      expect(JSON.parse(last_response.body)["resume"]["name"]).to eql("new resume name")
    end
    it "should let me create a new resume for another user as an admin" do
      post_with_auth "/api/v1/users/#{user.id}/resumes.json",{:resume=>{:name=>"another new resume name"}},adminuser.email,"abcd1234ABCD"
      expect(JSON.parse(last_response.body)["resume"]["name"]).to eql("another new resume name")
    end
    it "should let me destroy any resume as an admin" do
      delete_with_auth "/api/v1/users/#{user.id}/resumes/#{user.resumes.last.id.to_s}.json",adminuser.email,"abcd1234ABCD"
      expect(JSON.parse(last_response.body)).to eql({ "succes" => "resume destroyed"})
    end

    it "shouldnt let me change my own resume name as a guest" do
      patch_with_auth "/api/v1/users/#{guestuser.id}/resumes/#{user.resumes.first.id.to_s}.json",{:resume=>{:name=>"new resume name"}},guestuser.email,"abcd1234ABCD"
      it_should_disallow_this
    end
    it "shouldnt let me change somebody else's resume name as a guest" do
      patch_with_auth "/api/v1/users/#{user.id}/resumes/#{user.resumes.first.id.to_s}.json",{:resume=>{:name=>"new resume name"}},guestuser.email,"abcd1234ABCD"
      it_should_disallow_this
    end
    it "shouldnt let me delete my resume name as a guest" do
      delete_with_auth "/api/v1/users/#{guestuser.id}/resumes/#{user.resumes.first.id.to_s}.json",guestuser.email,"abcd1234ABCD"
      it_should_disallow_this
    end
    it "shouldnt let me delete somebody else's resume name as a guest" do
      delete_with_auth "/api/v1/users/#{user.id}/resumes/#{user.resumes.first.id.to_s}.json",guestuser.email,"abcd1234ABCD"
      it_should_disallow_this
    end

  end

  describe "API work history" , :type => :request do
    let!(:user) { FactoryGirl.create(:user,:user) }
    let!(:guestuser) { FactoryGirl.create(:user,:guest) }
    let!(:adminuser) { FactoryGirl.create(:user,:admin) }

    it "shouldn't let me change my own work history items as a guest" do
      patch_with_auth "/api/v1/users/#{guestuser.id}/resumes/#{guestuser.resumes.first.id.to_s}/work_histories/#{guestuser.resumes.first.work_histories.first.id.to_s}.json",{:work_history=>{:company_name=>"Changed Company Name",:from=>Date.new(2000,01,01),:until=>Date.new(2001,02,02),:position=>"Chief Testing Officer"}},guestuser.email,"abcd1234ABCD"
      it_should_disallow_this
    end


    it "should let me change my own work history items as a user" do
      patch_with_auth "/api/v1/users/#{user.id}/resumes/#{user.resumes.first.id.to_s}/work_histories/#{user.resumes.first.work_histories.first.id.to_s}.json",{:work_history=>{:company_name=>"Changed Company Name",:from=>Date.new(2000,01,01),:until=>Date.new(2001,02,02),:position=>"Chief Testing Officer"}},user.email,"abcd1234ABCD"
      expect(JSON.parse(last_response.body)["work_history"]["company_name"]).to eql("Changed Company Name")
    end
    it "shouldn't let me change others history items as a user" do
      patch_with_auth "/api/v1/users/#{guestuser.id}/resumes/#{guestuser.resumes.first.id.to_s}/work_histories/#{guestuser.resumes.first.work_histories.first.id.to_s}.json",{:work_history=>{:company_name=>"Changed Company Name",:from=>Date.new(2000,01,01),:until=>Date.new(2001,02,02),:position=>"Chief Testing Officer"}},user.email,"abcd1234ABCD"
      it_should_disallow_this
    end
    it "should let me delete my own work history items as a user" do
      delete_with_auth "/api/v1/users/#{user.id}/resumes/#{user.resumes.first.id.to_s}/work_histories/#{user.resumes.first.work_histories.first.id.to_s}.json",user.email,"abcd1234ABCD"
      expect(JSON.parse(last_response.body)).to eql({ "succes" => "work_history destroyed"})
    end
    it "should let me create my own work history items as a user" do
      post_with_auth "/api/v1/users/#{user.id}/resumes/#{user.resumes.first.id.to_s}/work_histories.json",{:work_history=>{:company_name=>"New Company Name",:from=>Date.new(2000,01,01),:until=>Date.new(2001,02,02),:position=>"Chief Testing Officer"}},user.email,"abcd1234ABCD"
      expect(JSON.parse(last_response.body)["work_history"]["company_name"]).to eql("New Company Name")
    end


    it "should let me change a users work history items as an admin" do
      patch_with_auth "/api/v1/users/#{user.id}/resumes/#{user.resumes.last.id.to_s}/work_histories/#{user.resumes.last.work_histories.first.id.to_s}.json",{:work_history=>{:company_name=>"Changed Company Name",:from=>Date.new(2000,01,01),:until=>Date.new(2001,02,02),:position=>"Chief Testing Officer"}},adminuser.email,"abcd1234ABCD"
      expect(JSON.parse(last_response.body)["work_history"]["company_name"]).to eql("Changed Company Name")
    end
    it "should let me delete a users work history items as an admin" do
      delete_with_auth "/api/v1/users/#{user.id}/resumes/#{user.resumes.first.id.to_s}/work_histories/#{user.resumes.first.work_histories.first.id.to_s}.json",adminuser.email,"abcd1234ABCD"
      expect(JSON.parse(last_response.body)).to eql({ "succes" => "work_history destroyed"})
    end
    it "should let me create a users work history items as a user" do
      post_with_auth "/api/v1/users/#{user.id}/resumes/#{user.resumes.first.id.to_s}/work_histories.json",{:work_history=>{:company_name=>"New Company Name",:from=>Date.new(2000,01,01),:until=>Date.new(2001,02,02),:position=>"Chief Testing Officer"}},adminuser.email,"abcd1234ABCD"
      expect(JSON.parse(last_response.body)["work_history"]["company_name"]).to eql("New Company Name")
    end
  end

  describe "API education history" , :type => :request do
    let!(:user) { FactoryGirl.create(:user,:user) }
    let!(:guestuser) { FactoryGirl.create(:user,:guest) }
    let!(:adminuser) { FactoryGirl.create(:user,:admin) }

    it "shouldn't let me change my own education history items as a guest" do
      patch_with_auth "/api/v1/users/#{guestuser.id}/resumes/#{guestuser.resumes.first.id.to_s}/education_histories/#{guestuser.resumes.first.education_histories.first.id.to_s}.json",{:education_history=>{:school_name=>"Higher Education School",:from=>Date.new(2000,01,01),:until=>Date.new(2001,02,02),:education=>"Basic Administration"}},guestuser.email,"abcd1234ABCD"
      it_should_disallow_this
    end


    it "should let me change my own education history items as a user" do
      patch_with_auth "/api/v1/users/#{user.id}/resumes/#{user.resumes.first.id.to_s}/education_histories/#{user.resumes.first.education_histories.first.id.to_s}.json",{:education_history=>{:school_name=>"Higher Education School",:from=>Date.new(2000,01,01),:until=>Date.new(2001,02,02),:education=>"Basic Administration"}},user.email,"abcd1234ABCD"
      expect(JSON.parse(last_response.body)["education_history"]["school_name"]).to eql("Higher Education School")
    end
    it "shouldn't let me change others history items as a user" do
      patch_with_auth "/api/v1/users/#{guestuser.id}/resumes/#{guestuser.resumes.first.id.to_s}/education_histories/#{guestuser.resumes.first.education_histories.first.id.to_s}.json",{:education_history=>{:school_name=>"Higher Education School",:from=>Date.new(2000,01,01),:until=>Date.new(2001,02,02),:education=>"Basic Administration"}},user.email,"abcd1234ABCD"
      it_should_disallow_this
    end
    it "should let me delete my own education history items as a user" do
      delete_with_auth "/api/v1/users/#{user.id}/resumes/#{user.resumes.first.id.to_s}/education_histories/#{user.resumes.first.education_histories.first.id.to_s}.json",user.email,"abcd1234ABCD"
      expect(JSON.parse(last_response.body)).to eql({ "succes" => "education_history destroyed"})
    end
    it "should let me create my own education history items as a user" do
      post_with_auth "/api/v1/users/#{user.id}/resumes/#{user.resumes.first.id.to_s}/education_histories.json",{:education_history=>{:school_name=>"New Company Name",:from=>Date.new(2000,01,01),:until=>Date.new(2001,02,02),:education=>"Basic Administration"}},user.email,"abcd1234ABCD"
      expect(JSON.parse(last_response.body)["education_history"]["school_name"]).to eql("New Company Name")
    end


    it "should let me change a users education history items as an admin" do
      patch_with_auth "/api/v1/users/#{user.id}/resumes/#{user.resumes.last.id.to_s}/education_histories/#{user.resumes.last.education_histories.first.id.to_s}.json",{:education_history=>{:school_name=>"Higher Education School",:from=>Date.new(2000,01,01),:until=>Date.new(2001,02,02),:education=>"Basic Administration"}},adminuser.email,"abcd1234ABCD"
      expect(JSON.parse(last_response.body)["education_history"]["school_name"]).to eql("Higher Education School")
    end
    it "should let me delete a users education history items as an admin" do
      delete_with_auth "/api/v1/users/#{user.id}/resumes/#{user.resumes.first.id.to_s}/education_histories/#{user.resumes.first.education_histories.first.id.to_s}.json",adminuser.email,"abcd1234ABCD"
      expect(JSON.parse(last_response.body)).to eql({ "succes" => "education_history destroyed"})
    end
    it "should let me create a users education history items as a user" do
      post_with_auth "/api/v1/users/#{user.id}/resumes/#{user.resumes.first.id.to_s}/education_histories.json",{:education_history=>{:school_name=>"New Company Name",:from=>Date.new(2000,01,01),:until=>Date.new(2001,02,02),:education=>"Basic Administration"}},adminuser.email,"abcd1234ABCD"
      expect(JSON.parse(last_response.body)["education_history"]["school_name"]).to eql("New Company Name")
    end




  end



end
