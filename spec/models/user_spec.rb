require 'spec_helper'

describe User do

  it { should have_many(:sites) }
  it { should eager_load(:roles) }

  describe ".mark_active_in!(messageboard)" do
    it "updates last_seen to now" do
      @now_time = Time.local(2011, 9, 1, 12, 0, 0)
      @messageboard = create(:messageboard)
      @user = create(:user)
      @user.member_of @messageboard

      Timecop.freeze(@now_time) do
        @user.mark_active_in!(@messageboard)
        @user.roles.for(@messageboard).first.last_seen.should == @now_time
      end
    end
  end

  describe "#admins?(messageboard)" do
     it "returns true for an admin" do
       stu = create(:user, :email => "stu@stu.com", :name => "stu")
       admin = create(:role, :level => "admin")
       messageboard = admin.messageboard
       stu.roles << admin
       stu.roles.reload

       stu.admins?(messageboard).should == true
     end

     it "returns true for a superadmin" do
       joel = build_stubbed(:user, :email => "jo@joel.com", :name => "jo", :superadmin => true)
       messageboard = build_stubbed(:messageboard)
       joel.admins?(messageboard).should == true
     end

     it "returns false for carl" do
       carl = build_stubbed(:user, :email => "carl@carl.com", :name => "carl")
       board = build_stubbed(:messageboard)
       carl.admins?(board).should == false
     end
  end

  describe "#superadmin?" do
    it "checks that a I can manage *everything*" do
      joel = build_stubbed(:user, :superadmin => true)
      joel.superadmin?.should == true
    end

    it "makes sure a regular user cannot" do
      carl = build_stubbed(:user)
      carl.superadmin?.should == false
    end
  end

  describe "#moderates?(messageboard)" do
    it "returns true for a moderator" do
      norah = create(:user, :email => "norah@norah.com", :name => "norah")
      moderator =create(:role, :level => 'moderator')
      norah.roles << moderator
      messageboard = moderator.messageboard
      norah.reload

      norah.moderates?(messageboard).should == true
    end

    it "returns false for joel" do
      joel = create(:user, :email => "joel@joel.com", :name => "joel")
      messageboard = create(:messageboard)
      joel.moderates?(messageboard).should == false
    end
  end

  describe "#member_of?(messageboard)" do
    it "returns true for a member" do
      john = create(:user)
      member = create(:role, :level => 'member')
      messageboard = member.messageboard
      john.roles << member
      john.reload

      john.member_of?(messageboard).should == true
    end
  end

  describe "#member_of(messageboard)" do
    it "sets the user as a member of messageboard" do
      tam = create(:user, :email => "tam@tam.com", :name => "tam")
      messageboard = create(:messageboard)
      tam.member_of(messageboard)
      tam.reload
      tam.member_of?(messageboard).should == true
    end

    it "makes the user an admin" do
      stephen = create(:user, :email => "steve@stephen.com", :name => "stephen")
      messageboard = create(:messageboard)
      stephen.member_of(messageboard, 'admin')
      stephen.reload
      stephen.admins?(messageboard).should == true
    end
  end

  describe "#after_save" do
    it "will update posts.user_email" do
      @shaun = create(:user, :name => "shaun", :email => "shaun@thredded.com")
      @topic = create(:topic, :last_user => @shaun)
      @post  = create(:post, :user => @shaun, :topic => @topic)
      @post.save

      @shaun.email = "shaun@notthredded.com"
      @shaun.save

      @post.reload
      @post.user_email.should == @shaun.email
    end
  end

  describe ".email" do
    it "will be valid" do
      @shaun = build_stubbed(:user, :name => "shaun", :email => "shaun@thredded.com")
      @shaun.should be_valid
    end

    it "will not be valid" do
      @shaun = build_stubbed(:user, :name => "shaun", :email => "shaun@.com")
      @shaun.should_not be_valid
    end
  end
end
