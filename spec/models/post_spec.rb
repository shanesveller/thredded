require 'spec_helper'
require 'ruby-debug'

describe Post do

  describe "#create" do

    before(:each) do
      @shaun = Factory(:user, :name => "shaun", :email => "shaun@thredded.com")
      @topic = Factory(:topic, :last_user => @shaun)
      @messageboard = @topic.messageboard
      @post  = Factory.build(:post)
      @joel = Factory(:user, :name => "joel", :email => "joel@thredded.com")
    end

    after(:each) do
      Timecop.return
    end

    it "updates the parent topic with the latest post author" do
      @post.user = @joel
      @post.topic = @topic
      @post.save
      @topic.last_user.should == @joel
    end

    it "increments the topic's and user's post counts" do
      3.times do; @topic.posts.create!(:user => @joel, :last_user => @joel, :content => "content", :messageboard => @messageboard); end
      @topic.reload.posts_count.should == 3
      @joel.reload.posts_count.should  == 3
    end
    
    it "updates the topic updated_at field to that of the new post" do
      @topic.posts.create(:user => @joel, :content => "posting here", :messageboard => @messageboard)
      @topic.posts.create(:user => @joel, :content => "posting some more", :messageboard => @messageboard)
      last_post = @topic.posts.last
      @topic.updated_at.should be_within(2.seconds).of(last_post.created_at)
    end
    
    it "sets the post user's email on creation" do
      @new_post = Post.create(:user => @shaun, 
                              :topic => @topic, 
                              :messageboard => @messageboard,
                              :content => "this is a post from shaun",
                              :ip => "255.255.255.0",
                              :filter => "bbcode")
      @new_post.user_email.should == @new_post.user.email
    end
    
  end
end
