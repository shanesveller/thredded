require 'spec_helper'

describe Post do

  describe "#create" do

    before(:each) do
      @topic = Factory(:topic)
      @post  = Factory.build(:post)
      @joel = Factory(:user, :name => "joel", :email => "joel@thredded.com")
    end

    it "updates the parent topic with the latest post author" do
      @post.user = @joel
      @post.topic = @topic
      @post.save
      @topic.last_user.should == @joel
    end

    it "increments the topic's and user's post counts" do
      3.times do; @topic.posts.create!(:user => @joel, :content => "content"); end
      @topic.reload.posts_count.should == 3
      @joel.reload.posts_count.should  == 3
    end
    
    it "updates the topic updated_at field to that of the new post" do
      @topic.posts.create(:user => @joel, :content => "posting here")
      @topic.posts.create(:user => @joel, :content => "posting some more")
      last_post = @topic.posts.last
      @topic.updated_at.should be_within(2.seconds).of(last_post.created_at)
    end
    
    it "sets the post user's email on creation" do
      @topic.posts.create(:content => "I should have a gravatar", :user => @joel)
      @topic.posts.last.user_email.should == "joel@thredded.com"
    end
    
  end
end
