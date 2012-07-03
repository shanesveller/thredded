require 'spec_helper'

describe EmailProcessor, '.process' do
  it 'returns false if user or board is not found' do
    EmailProcessor.stubs(:extract_user_and_messageboard).returns([])
    email = build(:email)

    EmailProcessor.process(email).should == false
  end

  it 'returns false if user does not have right permissions' do
    email = build(:email, from: 'nope@email.com')
    user = create(:user, email: 'user@email.com')
    messageboard = create(:messageboard, name: 'eh', security: 'private')
    EmailProcessor
      .stubs(:extract_user_and_messageboard)
      .returns([user, messageboard])

    EmailProcessor.process(email).should == false
  end

  context 'with existing user and messageboard' do
    before do
      joel = create(:user, email: 'joel@email.com')
      john = create(:user, email: 'john@email.com')
      mi = create(:messageboard, name: 'mi')
      john.member_of(mi)
      joel.member_of(mi)
      create(:topic, user: john, last_user: john, messageboard: mi,
        title: 'argument', hash_id: '1234')
    end

    it 'creates a new pending topic if no topic specified' do
      email = build(:email, from: 'john@email.com', to: 'mi',
        subject: 'introduction', body: 'HI!')
      EmailProcessor.process(email)

      latest_topic.pending?.should == true
      latest_topic.title.should == 'introduction'
      latest_post.source.should == 'email'
      latest_post.content.should == 'HI!'
    end

    it 'replies to a topic if specified' do
      email = build(:email, from: 'joel@email.com', to: 'mi-1234',
        subject: 'response', body: 'wrong!')
      EmailProcessor.process(email)

      latest_topic.pending?.should == false
      latest_topic.title.should == 'argument'
      latest_topic.last_user.email.should == 'joel@email.com'
      latest_post.source.should == 'email'
      latest_post.content.should == 'wrong!'
    end

    it 'attaches a file' do
      email = build(:email, :with_attachments, from: 'joel@email.com', to: 'mi',
        subject: 'photo!', body: 'awesome!')
      EmailProcessor.process(email)

      latest_post.attachments.should_not be_empty
    end

    def latest_topic
      Topic.first!
    end

    def latest_post
      Post.last!
    end
  end
end

describe EmailProcessor, '.extract_user_and_messageboard' do
  it 'returns both the user and messageboard if they exist' do
    email = build(:email, from: 'user@email.com', to: 'mi')
    user = create(:user, email: 'user@email.com')
    messageboard = create(:messageboard, name: 'mi')
    processor = EmailProcessor.new(email)

    processor.extract_user_and_messageboard.should == [user, messageboard]
  end

  it 'returns user and messageboard if to is for a specific thread' do
    email = build(:email, from: 'user@email.com', to: 'mi-1234')
    user = create(:user, email: 'user@email.com')
    messageboard = create(:messageboard, name: 'mi')
    processor = EmailProcessor.new(email)

    processor.extract_user_and_messageboard.should == [user, messageboard]
  end

  it 'returns empty array if user does not match' do
    email = build(:email, from: 'nope@email.com', to: 'mi')
    messageboard = create(:messageboard, name: 'mi')
    processor = EmailProcessor.new(email)

    processor.extract_user_and_messageboard.should == []
  end

  it 'returns empty array if messageboard does not match' do
    email = build(:email, from: 'user@email.com', to: 'nope')
    user = create(:user, email: 'user@email.com')
    processor = EmailProcessor.new(email)

    processor.extract_user_and_messageboard.should == []
  end
end
