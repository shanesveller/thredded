require 'spec_helper'

describe Category do
  #pending "add some examples to (or delete) #{__FILE__}"

  before(:each) do
    @user = Factory(:user, :name => "categorytest")
    @messageboard = Factory(:messageboard)
    @topic  = Factory(:topic, :messageboard => @messageboard)
    @category = Factory(:category, :messageboard => @messageboard)
  end

  it "should allow nil category_id" do
    @topic.category_id = nil
    @topic.should be_valid
  end

  it "should allow a category" do
    @topic.category = @category
    @topic.save
    @topic.category_id.should_not == nil
  end

end
