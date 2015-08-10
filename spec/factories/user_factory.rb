FactoryGirl.define do
	factory :user do |u|
		u.sequence(:email) {
			SecureRandom.uuid + "@example.com"
		}
		u.password "abcd1234ABCD"
		u.password_confirmation "abcd1234ABCD"
	end

  	factory :role_admin do
       		 after(:create) {|user| user.add_role(:admin)}
    	end

  	factory :role_guest do
       		 after(:create) {|user| user.add_role(:guest)}
    	end

    	factory :role_user do
        	after(:create) {|user| user.add_role(:user)}
    	end
	
end	
