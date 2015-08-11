class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.has_role?(:admin)
         can :manage, :all
    elsif user.has_role?(:user)
         can :read, :all
         can :manage, User, :id => user.id
         can :manage, Resume, :user_id => user.id
         can :manage, EducationHistory, :resume => {:user_id => user.id }
         can :manage, WorkHistory, :resume => {:user_id => user.id }
         can :create, Resume
         can :update, Resume
    else
        # guest user can read all
         can :read, :all
    end
  end
end
