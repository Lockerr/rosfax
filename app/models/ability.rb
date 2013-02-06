class Ability
  include CanCan::Ability

  def initialize(user, format=nil)
    user ||= User.new # guest user (not logged in)
    if user.is_admin?
        can :manage, :all
    elsif user.company != nil
        can [:read, :update, :create], Report
        can :manage, Schedule
        can :manage, Profile
        can :manage, Point
        can :manage, Company, id: user.company_id
        can :manage, User, user_id: user.id
    else
        can :read, Report
        can :read, Company
        can :create, Schedule
        can :read, Schedule if format == 'js'
    end
  end
end
