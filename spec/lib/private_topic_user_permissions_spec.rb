require 'spec_helper'
require 'topic_user_permissions'
require 'private_topic_user_permissions'

describe PrivateTopicUserPermissions do
  describe '#manageable?' do
    it 'is manageable by the user that created it' do
      user = build_stubbed(:user)
      private_topic = build_stubbed(:private_topic, user: user)
      permissions = PrivateTopicUserPermissions.new(private_topic, user)

      permissions.should be_manageable
    end
  end

  describe '#readable?' do
    it 'allows only users in the conversation to read' do
      me = build_stubbed(:user)
      him = build_stubbed(:user)
      them = build_stubbed(:user)
      private_topic = build_stubbed(:private_topic, user: me, users: [me, him])

      my_permissions = PrivateTopicUserPermissions.new(private_topic, me)
      his_permissions = PrivateTopicUserPermissions.new(private_topic, him)
      their_permissions = PrivateTopicUserPermissions.new(private_topic, them)

      my_permissions.should be_readable
      his_permissions.should be_readable
      their_permissions.should_not be_readable
    end
  end

  describe '#creatable?' do
    it 'delegates to normal Topic permissions' do
      user = build_stubbed(:user)
      private_topic = build_stubbed(:private_topic, user: user)

      permissions = stub('creatable?' => true)
      TopicUserPermissions.stubs(new: permissions)
      PrivateTopicUserPermissions
        .new(private_topic, user)
        .creatable?

      permissions.should have_received(:creatable?)
    end
  end

  describe '#listable?' do
    it 'allows users with private messages to list them' do
      user = build_stubbed(:user)
      user.stubs(private_topics: ['topic', 'topic'])
      private_topic = PrivateTopic.new
      permissions = PrivateTopicUserPermissions.new(private_topic, user)

      permissions.should be_listable
    end

    it 'does not allow users with no private messages to list them' do
      user = build_stubbed(:user)
      user.stubs(private_topics: [])
      private_topic = PrivateTopic.new
      permissions = PrivateTopicUserPermissions.new(private_topic, user)

      permissions.should_not be_listable
    end
  end
end
