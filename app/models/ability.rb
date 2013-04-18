class Ability
  include CanCan::Ability

  def initialize(user)
    # roles per messageboard
    # superadmin  - can do anything across the site
    # admin       - a moderator that can do anything for a given messageboard
    # moderator   - member that can create/update categories. can post on some/all of the messageboards
    # member      - user that's participating in a given messageboard
    # logged_in   - herp
    # anonymous   - derp

    # if messageboard is private          - members can read topics listing
    # if messageboard is logged_in        - logged_in can read
    # if messageboard is public           - anonymous can read
    # if posting permission is members    - members can post
    # if posting permission is logged_in  - logged in can post
    # if posting permission is anonymous  - anonymous can post

    user ||= NullUser.new

    can :manage, :all if user.superadmin?

    can :read, Messageboard do |messageboard|
      user.can_read_messageboard?(messageboard)
    end

    can :manage, Topic do |topic|
      user.admins?(topic.messageboard) || topic.user == user
    end

    can :read, Topic do |topic|
      user.can_read_messageboard?(topic.messageboard)
    end

    can :create, Topic do |topic|
      user.member_of?(topic.messageboard)
    end

    can :create, Topic do |topic|
      messageboard = topic.messageboard
      messageboard_permissions = messageboard.restricted_to_logged_in? ||
        messageboard.posting_for_logged_in?
      messageboard_permissions && user.valid?
    end

    cannot :manage, PrivateTopic

    can :manage, PrivateTopic, user_id: user.id

    can :create, PrivateTopic do |private_topic|
      user.member_of?(private_topic.messageboard)
    end

    can :read, PrivateTopic do |private_topic|
      private_topic.users.include?(user)
    end

    can :manage, Post do |post|
      user.admins?(post.topic.messageboard) || post.user == user
    end
  end
end
