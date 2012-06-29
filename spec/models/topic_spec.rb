require 'spec_helper'

describe Topic do

  before(:each) do
    @user = create(:user)
    @messageboard = create(:messageboard)
    @topic  = create(:topic, :messageboard => @messageboard)
  end

  it "should be associated to a messageboard" do
    @topic.messageboard = nil
    @topic.should_not be_valid
  end

  it "is public by default" do
    @topic.public?.should be_true
  end

  it "changes updated_at when a new post is added" do
    old = @topic.updated_at
    @post = @topic.posts.create({:content => "awesome", :filter => "bbcode", :messageboard => @messageboard, :user => @user})
    @topic.reload.updated_at.should_not == old
  end

  it "does not change updated_at when an old post is edited" do
    @post = create(:post)
    old = @post.topic.updated_at
    @post.content = "alternative content"
    @post.save
    @topic.reload.updated_at.to_s.should == old.to_s
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
      @user = create(:user, :name => "coolkid")
      @user.member_of(@topic.messageboard)
      ability = Ability.new(@user)
      ability.can?(:create, @topic).should be_true
    end

  end

end
