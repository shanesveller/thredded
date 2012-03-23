require 'spec_helper'

describe Topic do

  before(:each) do
    @user = Factory(:user)
    @messageboard = Factory(:messageboard)
    @topic  = Factory(:topic, :messageboard => @messageboard)
  end

  it "should be associated to a messageboard" do
    @topic.messageboard = nil
    @topic.should_not be_valid
  end

  it "is public by default" do
    @topic.public?.should be_true
  end

  context "when its parent messageboard is for logged in users only" do
    before(:each) do
      @topic.messageboard.security = 'logged_in'
    end

    it "is not readable by anonymous visitors" do
      @user = User.new  # this user is not valid, so - not logged in
      ability = Ability.new(@user)
      ability.can?(:read, @topic).should be_false
    end

    it "is readable by a logged in user" do
      ability = Ability.new(@user)
      ability.can?(:read, @topic).should be_true
    end
  end

  context "when its parent messageboard is private" do
    
    before(:each) do
      @topic.messageboard.security = 'private'
    end

    it "is not readable by non members of the board" do
      ability = Ability.new(@user)
      ability.can?(:read, @topic).should be_false
    end

    it "cannot be created by a non member of the board" do
      ability = Ability.new(@user)
      ability.can?(:create, @topic).should be_false
    end

    it "can be created by a member of the board" do
      @user = Factory(:user, :name => "coolkid")
      @user.member_of(@topic.messageboard)
      ability = Ability.new(@user)
      ability.can?(:create, @topic).should be_true
    end

  end

end
