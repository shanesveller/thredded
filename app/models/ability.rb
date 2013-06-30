class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= NullUser.new

    alias_action :edit, to: :update

    can :manage, :all if user.superadmin?

    can :read, Messageboard do |messageboard|
      MessageboardUserPermissions.new(messageboard, user).readable?
    end

    can :manage, Topic do |topic|
      TopicUserPermissions.new(topic, user).manageable?
    end

    can :read, Topic do |topic|
      (topic.private? && PrivateTopicUserPermissions.new(topic, user).readable?) ||
        TopicUserPermissions.new(topic, user).readable?
    end

    can :create, Topic do |topic|
      TopicUserPermissions.new(topic, user).creatable?
    end

    cannot :manage, PrivateTopic
    cannot :read, PrivateTopic

    can :manage, PrivateTopic do |private_topic|
      PrivateTopicUserPermissions.new(private_topic, user).manageable?
    end

    can :create, PrivateTopic do |private_topic|
      PrivateTopicUserPermissions.new(private_topic, user).creatable?
    end

    can :read, PrivateTopic do |private_topic|
      PrivateTopicUserPermissions.new(private_topic, user).indexable? &&
      PrivateTopicUserPermissions.new(private_topic, user).readable?
    end

    can :create, Post do |post|
      PostUserPermissions.new(post, user).creatable? &&
        TopicUserPermissions.new(post.topic, user).creatable?
    end

    can :update, Post do |post|
      PostUserPermissions.new(post, user).manageable?
    end

    can :read, Post
  end
end
