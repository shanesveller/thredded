require 'spec_helper'

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
      @john.recently_active_in!(@m)
      @joe.recently_active_in!(@m)

      @m.active_users[0].name.should == "Joe"
      @m.active_users[1].name.should == "John"
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

