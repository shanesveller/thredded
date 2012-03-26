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
      can_read_messageboard(messageboard, user)
    end
    
    can :read, Topic do |topic|
      can_read_messageboard(topic.messageboard, user) && 
      ( topic.public? ||
        topic.private? && topic.users.include?(user) ||
        user.valid? && topic.public?
      )
    end

    can :create, Topic do |topic|
      ( (topic.messageboard.restricted_to_private? || topic.messageboard.posting_for_members?) && user.member_of?(topic.messageboard)) ||
      ( (topic.messageboard.restricted_to_logged_in? || topic.messageboard.posting_for_logged_in? ) && user.valid?) ||
      topic.messageboard.public? && topic.messageboard.posting_for_anonymous?
    end

    can :manage, Topic do |topic|
      user.admins?(topic.messageboard) ||
      topic.user == user
    end
    
    can :manage, Post do |post|
      user.admins?(post.topic.messageboard) || post.user == user
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

  private
    def can_read_messageboard(messageboard, user)
      (messageboard.restricted_to_private?    && user.member_of?(messageboard)) ||
      (messageboard.restricted_to_logged_in?  && user.valid?) ||
      messageboard.public?
    end

end
