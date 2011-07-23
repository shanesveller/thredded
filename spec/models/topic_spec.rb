require 'spec_helper'

describe Topic do

  before(:each) do
    @user1 = Factory(:user, :name => "user1")
    @user2 = Factory(:user, :name => "user2")
    @user3 = Factory(:user, :name => "user3")

    @messageboard = Factory(:messageboard)

    @public_topic  = Factory(:topic, :messageboard => @messageboard)
  end

  it "should be associated to a messageboard" do
    @public_topic.messageboard = nil
    @public_topic.should_not be_valid
  end

  it "is public by default" do
    @public_topic.public?.should be_true
  end

  context "when its parent messageboard is for logged in users only" do
    before(:each) do
      @messageboard.security = 'logged_in'
      @topic = Factory(:topic, :messageboard => @messageboard)
    end

    it "is not readable by anonymous visitors" do
      @user = User.new  # this user is not valid, so - not logged in
      ability = Ability.new(@user)
      ability.can?(:read, @topic).should be_false
    end

    it "is readable by a logged in user" do
      ability = Ability.new(@user1)
      ability.can?(:read, @topic).should be_true
    end
  end

  context "when its parent messageboard is private" do
    
    before(:each) do
      @messageboard.security = 'private'
    end

    it "is not readable by non members of the board" do
      @topic = Factory(:topic, :messageboard => @messageboard)
      ability = Ability.new(@user2)
      ability.can?(:read, @topic).should be_false
    end

    it "cannot be created by a non member of the board" do
      @topic = Topic.new
      @topic.messageboard = @messageboard
      ability = Ability.new(@user2)
      ability.can?(:create, @topic).should be_false
    end

    it "can be created by a member of the board" do
      @topic = Topic.new
      @topic.messageboard = @messageboard
      @member = Factory(:user, :name => "coolkid")
      @member.member_of(@messageboard)
      ability = Ability.new(@member)
      ability.can?(:create, @topic).should be_true
    end

  end

end
