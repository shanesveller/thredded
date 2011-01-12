require 'spec_helper'

describe Topic do

  before(:each) do
    @user1 = Factory(:user, :name => "user1")
    @user2 = Factory(:user, :name => "user2")
    @user3 = Factory(:user, :name => "user3")

    @messageboard = Factory(:messageboard, :name => "kekbur")

    @private_topic = Factory(:topic, :messageboard => @messageboard)
    @public_topic = Factory(:topic, :messageboard => @messageboard)

    @private_topic.users << @user1
    @private_topic.users << @user2
    @private_topic.save
  end

  it "should be associated to a messageboard" do
    @topic = Topic.new(:post_count => 1)
    @topic.should_not be_valid
  end

  it "is public by default" do
    @public_topic.public?.should be_true
  end

  it "is private when it has users" do
    @private_topic.private?.should be_true
  end

  context "when it is private" do

    it "does not allow someone not involved to read the topic" do
      ability = Ability.new(@user3)
      ability.can?(:read, @private_topic).should be_false
    end

    it "allows someone included in the topic to read it" do
      ability = Ability.new(@user2)
      ability.can?(:read, @private_topic).should be_true
    end

  end

  context "when its parent messageboard is for logged in users only" do
    before(:each) do
      @messageboard = Factory(:messageboard, :security => :logged_in)
      @topic = Factory(:topic, :messageboard => @messageboard)
    end

    it "is not readable by anonymous visitors" do
      @user = User.new  # this user is not valid, so - not logged in
      ability = Ability.new(@user)
      ability.can?(:read, @topic).should be_false
    end

    it "is readable by a logged in user" do
      @user = Factory(:user) # user is valid, so - logged in
      ability = Ability.new(@user)
      ability.can?(:read, @topic).should be_true
    end
  end

  context "when its parent messageboard is private" do
    
    before(:each) do
      @messageboard = Factory(:messageboard, :security => :private)
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
