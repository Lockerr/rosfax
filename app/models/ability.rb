class Ability
  include CanCan::Ability

  def initialize(user, request=nil)
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
        can :manage, Block
    else
        # raise request.params[:access_key]
        can :read, Report, publish: true
        can :read, Report, publish: false if Report.where(id: request.params[:id], access_key: request.params[:access_key]).count == 1
        can :access, Report
        can :read, Company
        can :create, Schedule
        can :read, Schedule if request.format == 'js'
    end
  end
end