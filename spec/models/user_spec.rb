require 'spec_helper'

describe User do

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

  describe "#admins?(messageboard)" do
    it "returns true for an admin" do
      stu = Factory(:user)
      thredded = Factory(:messageboard)
      stu.roles << Factory(:role, :level => :admin, :messageboard => thredded)
      stu.reload

      stu.admins?(thredded).should == true
    end

    it "returns true for a superadmin" do
      joel = Factory(:user, :superadmin => true)
      lgnlgn = Factory(:messageboard)

      joel.admins?(lgnlgn).should == true
    end

    it "returns false for carl" do
      carl = Factory(:user)
      board = Factory(:messageboard)

      carl.admins?(board).should == false
    end
  end

  describe "#moderates?(messageboard)" do
    it "returns true for a moderator" do
      norah = Factory(:user)
      ja = Factory(:messageboard)
      norah.roles << Factory(:role, :level => :moderator, :messageboard => ja)
      norah.reload

      norah.moderates?(ja).should == true
    end

    it "returns false for joel" do
      joel = Factory(:user)
      ja = Factory(:messageboard)

      joel.moderates?(ja).should == false
    end
  end

  describe "#member_of?(messageboard)" do
    it "returns true for a member" do
      john = Factory(:user)
      mi = Factory(:messageboard)
      john.roles << Factory(:role, :level => :member, :messageboard => mi)
      john.reload

      john.member_of?(mi).should == true
    end
  end

end
