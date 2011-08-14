class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new # anonymous visitor
    
    # roles per messageboard
    # superadmin  - can do anything across the site
    # admin       - a moderator that can do anything for a given messageboard
    # moderator   - member that can create/update categories. can post on some/all of the messageboards
    # member      - user that's participating in a given messageboard
    # logged_in   - herp
    # anonymous   - derp
    
    if user.superadmin?
      can :manage, :all
    end
    
    can :read, Site do |site|
      user.valid? || site.permission == "public"
    end

    can :read, Messageboard do |messageboard|
      (messageboard.restricted_to_private?    && user.member_of?(messageboard)) ||
      (messageboard.restricted_to_logged_in?  && user.valid?) ||
      messageboard.public?
    end
    
    can :read, Topic do |topic|
      topic.messageboard.public? && topic.public? ||
      topic.messageboard.public? && topic.private? && topic.users.include?(user) ||
      topic.messageboard.restricted_to_logged_in? && user.logged_in? && topic.public? ||
      topic.messageboard.restricted_to_logged_in? && user.logged_in? && topic.private? && topic.users.include?(user) ||
      topic.messageboard.restricted_to_private? && user.member_of?(topic.messageboard) && topic.public? ||
      topic.messageboard.restricted_to_private? && user.member_of?(topic.messageboard) && topic.private? && topic.users.include?(user) 
    end

    can :create, Topic do |topic|
      (topic.messageboard.restricted_to_private?    && user.member_of?(topic.messageboard)) ||
      (topic.messageboard.restricted_to_logged_in?  && user.valid?) ||
      topic.messageboard.public?
    end

    can :manage, Topic do |topic|
      user.admins?(topic.messageboard) ||
      topic.user == user.name
    end
    
    can :manage, Post do |post|
      user.admins?(post.topic.messageboard) || post.user == user.name
    end
    

    # if messageboard is private
    #   - members can read topics listing
    #
    # if messageboard is logged_in
    #   - logged_in can read
    #
    # if messageboard is public
    #   - anonymous can read
    
    # if posting permission is members
    #   - members can post
    #
    # if posting permission is logged_in
    #   - logged in can post
    #
    # if posting permission is anonymous
    #   - anonymous can post


  end
end
