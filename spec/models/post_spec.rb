require 'spec_helper'

describe Post do
  describe "#create" do
    it "updates the parent topic with the latest post author" do
      topic = Factory(:topic)
      topic.posts.create(:content => "test content", :user => "joel", :ip => "127.0.0.1")

      topic.last_user.should == "joel"
    end

    it "increments the topic post count" do
      topic = Factory(:topic)
      topic.posts.create(:content => "more content", :user => "fred", :ip => "127.0.0.1")
      topic.posts.create(:content => "a second post", :user => "john", :ip => "127.0.0.3")

      topic.post_count.should == 2
    end
  end
end
