FactoryGirl.define do


  factory :work_history do |w|
    w.sequence(:company_name) { |n| "Company #{n}" }
    w.position "Developer"
    w.sequence(:from) { |n| Date.new(2014,01,01) - n.years }
    w.sequence(:until) { |n| Date.new(2014,12,31) - n.years }
    resume
  end

  factory :education_history do |w|
    w.sequence(:school_name) { |n| "School #{n}" }
    w.education "Class in something"
    w.sequence(:from) { |n| Date.new(2014,01,01) - n.years }
    w.sequence(:until) { |n| Date.new(2014,12,31) - n.years }
    resume
  end


  factory :resume do |r|
    r.sequence(:name) { |n| "Resume #{n}" }
    user
    after :create do |resume|
      FactoryGirl.create_list(:work_history,4,:resume=> resume)
      FactoryGirl.create_list(:education_history,4,:resume=> resume)
    end
  end

	factory :user do |u|
		u.sequence(:email) {
			SecureRandom.uuid + "@example.com"
		}
		u.password "abcd1234ABCD"
		u.password_confirmation "abcd1234ABCD"
    trait :admin do
           before(:create) {|user| user.add_role(:admin)}
    end
    trait :user do
           before(:create) {|user| user.add_role(:user)}
    end
    trait :guest do
           before(:create) {|user| user.add_role(:guest)}
    end
    after :create do |user|
      FactoryGirl.create_list(:resume,2,:user=> user)
    end
	end

end
