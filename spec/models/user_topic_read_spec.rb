require 'spec_helper'
require 'debugger'

describe UserTopicRead do
  it { should have_db_column(:user_id) }
  it { should have_db_column(:topic_id) }
  it { should have_db_column(:post_id) }
  it { should have_db_column(:posts_count) }
  it { should have_db_column(:page) }

  it { should have_db_index(:user_id) }
  it { should have_db_index(:topic_id) }
  it { should have_db_index(:post_id) }
  it { should have_db_index(:posts_count) }
  it { should have_db_index(:page) }
end

describe UserTopicRead, '#find_or_create_by_user_and_topic' do
  it 'creates a record if not found' do
    current_count = UserTopicRead.count
    user = create(:user)
    topic = create(:topic, :with_5_posts)
    user_topic_read = 
      UserTopicRead.find_or_create_by_user_and_topic(user, topic)
    UserTopicRead.count.should == current_count + 1
  end

  it 'finds an existing record' do
    user = create(:user)
    topic = create(:topic)
    existing_topic_read = create(:user_topic_read, topic_id: topic.id,
      user_id: user.id)
    user_topic_read = 
      UserTopicRead.find_or_create_by_user_and_topic(user, topic)
    user_topic_read.should == existing_topic_read
  end
end

describe UserTopicRead, '#update_status' do
  it 'updates a users current read status' do
    topic_read = create(:user_topic_read)
    last_post = stub('Post', id: 10)
    posts_count = 20
    page = 1
    topic_read.update_status(last_post, posts_count)
    topic_read.reload.posts_count.should == posts_count
    topic_read.reload.post_id.should == last_post.id
  end
end
