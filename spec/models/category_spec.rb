require 'spec_helper'

describe Category do
  before(:each) do
    @user         = create(:user, name: "categorytest")
    @messageboard = create(:messageboard)
    @topic        = create(:topic, messageboard: @messageboard)
    @category     = create(:category, messageboard: @messageboard)
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
