class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # anonymous visitor
    
    # roles per messageboard
    # superadmin  - can do anything across the site
    # admin       - a moderator that can do anything for a given messageboard
    # moderator   - member that can create/update categories. can post on some/all of the messageboards
    # member      - user that's participating in a given messageboard

    
    if user.superadmin?
      can :manage, :all
    else
      can :read, :all
    end

  end
end
