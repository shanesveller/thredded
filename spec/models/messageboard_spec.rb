require 'spec_helper'
require 'debugger'

describe Messageboard do

  before(:each) do
    @m = Factory(:messageboard)
  end

  describe ".active_users" do
    it "returns a list of users active in this messageboard" do
      @john = FactoryGirl.create(:user, :name => "John")
      @joe  = FactoryGirl.create(:user, :name => "Joe")
      @john.member_of @m
      @joe.member_of @m
      @john.mark_active_in!(@m)
      @joe.mark_active_in!(@m)

      @m.active_users[0].name.should == "Joe"
      @m.active_users[1].name.should == "John"
    end
  end

  describe ".postable_by?" do
    before(:each) do
      @current_user = FactoryGirl.create(:user)
    end
    describe "for public boards" do
      before(:each) do
        @m.security = 'public'
      end
      it "should be true if allows anonymous" do
        @current_user = nil
        @m.postable_by?(@current_user).should be_true
      end
      it "should be false if for logged_in" do
        @m.postable_by?(@current_user).should be_true
      end
      it "should be false if for members" do
        @current_user.member_of(@m)
        @m.postable_by?(@current_user).should be_true
      end
    end
    describe "for logged_in boards" do
      before(:each) do
        @m.security = 'logged_in'
      end
      it "should be false if anonymous and allows anonymous posting" do
        @current_user = nil
        @m.postable_by?(@current_user).should be_false
      end
      it "should be true if logged in and allows logged_in posting" do
        @m.posting_permission = "logged_in"
        @m.postable_by?(@current_user).should be_true
      end
      it "should be true if a member and allows logged_in posting" do
        @m.posting_permission = "logged_in"
        @current_user.member_of(@m)
        @m.postable_by?(@current_user).should be_true
      end
    end
    describe "for private boards" do
      before(:each) do
        @m.security = 'private'
      end
      it "should be false if anonymous and allows anonymous" do
        @current_user = nil
        @m.postable_by?(@current_user).should be_false
      end
      it "should be false if user is not a member and posting permission is logged in" do
        @m.posting_permission = "members"
        @m.postable_by?(@current_user).should be_false
      end
      it "should be true if a member and allows member posting" do
        @m.posting_permission = "members"
        @current_user.member_of(@m)
        @m.postable_by?(@current_user).should be_true
      end
    end
  end

  describe "#restricted_to_private?" do
    it "checks whether a messageboard is private and restricted to members" do
      @m.security = 'private'
      @m.restricted_to_private?.should == true
    end
  end

  describe "#restricted_to_logged_in?" do
    it "checks whether a messageboard is restricted to only those that are logged in" do
      @m.security = 'logged_in'
      @m.restricted_to_logged_in?.should == true
    end
  end

  describe "#public?" do
    it "checks whether a messageboard is open for all to read" do
      @m.security = 'public'
      @m.public?.should == true
    end
  end

end

