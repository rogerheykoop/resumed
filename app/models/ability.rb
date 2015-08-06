class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    case(user.role)
    when "admin"
         can :manage, :all
    when "user"
         can :read, :all
         can :manage, Resume, :user_id => user.id
         can :manage, EducationHistory, :user_id => user.id
         can :manage, WorkHistory, :user_id => user.id
         can :create, Resume
         can :update, Resume
    else
        # guest user can read all
         can :read, :all
    end
  end
end
