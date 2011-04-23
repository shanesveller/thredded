require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the PostsHelper. For example:
#
# describe PostsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe PostsHelper do

  describe "render_content_for BBCode" do
    before(:each) do
      @messageboard = Factory(:messageboard, :name=> "kek")
      @topic = Factory(:topic, :post_count => 1, :messageboard => @messageboard)
    end
    
    it "renders html from bbcode markup" do
      @topic.posts << Factory(:post, :content => "[i]this is italic[/i]", :filter => :bbcode)
      helper.render_content_for(@topic.posts.last).should eq("<em>this is italic</em>")
    end

    it "renders html from textile markup" do
      @topic.posts << Factory(:post, :content => "_this is italic_", :filter => :textile)
      helper.render_content_for(@topic.posts.last).should eq("<p><em>this is italic</em></p>")
    end
  end

end

