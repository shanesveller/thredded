require 'spec_helper'
require 'topic_user_permissions'

describe TopicUserPermissions do
  describe '#creatable?' do
    let(:topic){ create(:topic) }

    it 'allows members to create a topic' do
      user = create(:user)
      messageboard = topic.messageboard
      messageboard.add_member(user)
      permissions = TopicUserPermissions.new(topic, user)

      permissions.should be_creatable
    end

    it 'does not allow non-members to create a topic' do
      user = create(:user)
      messageboard = topic.messageboard
      permissions = TopicUserPermissions.new(topic, user)

      permissions.should_not be_creatable
    end

    it 'allows non-members to create if it is restricted to logged in members' do
      user = create(:user)
      messageboard = create(:messageboard, :restricted_to_logged_in)
      topic = create(:topic, messageboard: messageboard)
      permissions = TopicUserPermissions.new(topic, user)

      permissions.should be_creatable
    end

    it 'allows non-members to create if it allows posting for logged in members' do
      user = create(:user)
      messageboard = create(:messageboard, :postable_for_logged_in)
      topic = create(:topic, messageboard: messageboard)
      permissions = TopicUserPermissions.new(topic, user)

      permissions.should be_creatable
    end
  end

  describe '#manageable?' do
    context 'when it is private' do
      let(:topic){ create(:topic) }

      it 'is manageable by superadmins' do
        user = create(:user, :superadmin)
        permissions = TopicUserPermissions.new(topic, user)

        permissions.should be_manageable
      end

      it 'is manageable when started by the user' do
        user = create(:user)
        topic = create(:topic, user_id: user.id)
        permissions = TopicUserPermissions.new(topic, user)

        permissions.should be_manageable
      end

      it 'is manageable when the user administrates the board' do
        user = create(:user)
        messageboard = create(:messageboard)
        messageboard.add_member(user, 'admin')
        topic = create(:topic, messageboard: messageboard)
        permissions = TopicUserPermissions.new(topic, user)

        permissions.should be_manageable
      end

      it 'is not manageable by another user' do
        user = create(:user)
        another_user = create(:user)
        topic = create(:topic, user_id: user.id)
        permissions = TopicUserPermissions.new(topic, another_user)

        permissions.should_not be_manageable
      end

      it 'is not manageable by a random user' do
        user = create(:user)
        permissions = TopicUserPermissions.new(topic, user)

        permissions.should_not be_manageable
      end
    end
  end
end
