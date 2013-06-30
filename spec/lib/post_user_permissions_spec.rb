require 'spec_helper'
require 'post_user_permissions'

describe PostUserPermissions do
  describe '#manageable?' do
    it 'can be managed by the user who started it' do
      user = build_stubbed(:user)
      post = build_stubbed(:post, user: user)
      permissions = PostUserPermissions.new(post, user)

      permissions.should be_manageable
    end

    it 'can be managed by superadmin' do
      user = build_stubbed(:user)
      post = build_stubbed(:post, user: user)
      permissions = PostUserPermissions.new(post, user)

      permissions.should be_manageable
    end
  end

  describe '#topic_locked?' do
    it 'cannot be created if the post is new and the topic is locked' do
      user = create(:user)
      topic = create(:topic, :locked, user: user)
      post = build(:post, topic: topic, user: user)
      permissions = PostUserPermissions.new(post, user)

      permissions.topic_locked?.should be_true
    end

    it 'can be created if the topic is not locked' do
      user = create(:user)
      topic = create(:topic, title: 'unlocked!', user: user)
      post = create(:post, topic: topic, user: user)
      permissions = PostUserPermissions.new(post, user)

      permissions.topic_locked?.should be_false
    end
  end
end
