require 'spec_helper'

describe User do

  it { should have_many(:sites) }

  describe ".mark_active_in!(messageboard)" do
    it "updates last_seen to now" do
      @now_time = Time.local(2011, 9, 1, 12, 0, 0)
      @messageboard = FactoryGirl.create(:messageboard)
      @user = FactoryGirl.create(:user)
      @user.member_of @messageboard

      Timecop.freeze(@now_time) do
        @user.mark_active_in!(@messageboard)
        @user.roles.for(@messageboard).first.last_seen.should == @now_time
      end
    end
  end

  describe "#admins?(messageboard)" do
     it "returns true for an admin" do
       stu = Factory(:user, :email => "stu@stu.com", :name => "stu")
       admin = Factory(:role, :level => "admin")
       messageboard = admin.messageboard
       stu.roles << admin
       stu.roles.reload

       stu.admins?(messageboard).should == true
     end

     it "returns true for a superadmin" do
       joel = Factory(:user, :email => "jo@joel.com", :name => "jo", :superadmin => true)
       messageboard = Factory(:messageboard)
       joel.admins?(messageboard).should == true
     end

     it "returns false for carl" do
       carl = Factory(:user, :email => "carl@carl.com", :name => "carl")
       board = Factory(:messageboard)
       carl.admins?(board).should == false
     end
  end

  describe "#superadmin?" do
    it "checks that a I can manage *everything*" do
      joel = Factory(:user, :superadmin => true)
      joel.superadmin?.should == true
    end

    it "makes sure a regular user cannot" do
      carl = Factory(:user)
      carl.superadmin?.should == false
    end
  end

  describe "#moderates?(messageboard)" do
    it "returns true for a moderator" do
      norah = Factory(:user, :email => "norah@norah.com", :name => "norah")
      moderator = Factory(:role, :level => 'moderator')
      norah.roles << moderator
      messageboard = moderator.messageboard
      norah.reload

      norah.moderates?(messageboard).should == true
    end

    it "returns false for joel" do
      joel = Factory(:user, :email => "joel@joel.com", :name => "joel")
      messageboard = Factory(:messageboard)
      joel.moderates?(messageboard).should == false
    end
  end

  describe "#member_of?(messageboard)" do
    it "returns true for a member" do
      john = Factory(:user)
      member = Factory(:role, :level => 'member')
      messageboard = member.messageboard
      john.roles << member
      john.reload

      john.member_of?(messageboard).should == true
    end
  end

  describe "#member_of(messageboard)" do
    it "sets the user as a member of messageboard" do
      tam = Factory(:user, :email => "tam@tam.com", :name => "tam")
      messageboard = Factory(:messageboard)
      tam.member_of(messageboard)
      tam.reload
      tam.member_of?(messageboard).should == true
    end

    it "makes the user an admin" do
      stephen = Factory(:user, :email => "steve@stephen.com", :name => "stephen")
      messageboard = Factory(:messageboard)
      stephen.member_of(messageboard, 'admin')
      stephen.reload
      
      stephen.admins?(messageboard).should == true
    end
  end

  describe "#after_save" do
    it "will update posts.user_email" do

      @shaun = Factory(:user, :name => "shaun", :email => "shaun@thredded.com")
      @topic = Factory(:topic, :last_user => @shaun)
      @post  = Factory.build(:post, :user => @shaun, :topic => @topic)
      @post.save

      @shaun.email = "shaun@notthredded.com"
      @shaun.save

      @post.reload
      @post.user_email.should == @shaun.email

    end
  end

  describe ".email" do
    it "will be valid" do
      @shaun = Factory.build(:user, :name => "shaun", :email => "shaun@thredded.com")
      @shaun.should be_valid
    end

    it "will not be valid" do
      @shaun = Factory.build(:user, :name => "shaun", :email => "shaun@.com")
      @shaun.should_not be_valid
    end
  end

end
