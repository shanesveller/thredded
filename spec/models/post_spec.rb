require 'spec_helper'

describe Post do
  describe "#create" do
    before(:each) do
      @messageboard = Factory(:messageboard)
    end

    it "updates the parent topic with the latest post author" do
      topic = Factory(:topic, :post_count => 1, :messageboard => @messageboard)
      topic.posts.create(:content => "test content", :user => "joel", :ip => "127.0.0.1")

      topic.last_user.should == "joel"
    end

    it "increments the topic post count" do
      topic = Factory(:topic, :post_count => 1, :messageboard => @messageboard)
      topic.posts.create(:content => "more content", :user => "fred")
      topic.posts.create(:content => "a second post", :user => "john")

      topic.post_count.should == 3
    end

    it "increments a users' posts count" do
      # @messageboard = Factory(:messageboard)
      newguy =  User.create!(:name => "newguy", :email => "newb@ee.com", :password => "password")
      topic = Factory(:topic, :post_count => 1, :messageboard => @messageboard)
      topic.posts.create(:content => "my first post", :user => "newguy")
      topic.posts.create(:content => "my second post", :user => "newguy")
      
      newguy.reload
      newguy.posts_count.should == 2
    end
    
    it "updates the topic updated_at field to that of the new post" do
      topic = Factory(:topic, :post_count => 1, :messageboard => @messageboard)
      topic.posts.create(:content => "posting here", :user => "sal")
      topic.posts.create(:content => "posting some more", :user => "sdjg")
      last_post = topic.posts.last
      
      topic.updated_at.should == last_post.created_at
    end
  end
end
