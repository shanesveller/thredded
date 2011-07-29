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
      @post = Factory(:post)
    end
    
    it "renders html from bbcode markup" do
      @post.content = "[i]this is italic[/i]"
      @post.filter  =  'bbcode'
      helper.render_content_for(@post).should eq("<em>this is italic</em>")
    end

    it "renders html from textile markup" do
      @post.content = "_this is italic_"
      @post.filter  =  'textile'
      helper.render_content_for(@post).should eq("<p><em>this is italic</em></p>")
    end
  end

end

