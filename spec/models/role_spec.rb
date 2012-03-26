require 'spec_helper'

describe Role do

  before(:each) do
    @admin_user = Factory(:user, :email => "role@admin.com", :name => "adminUser")
    @admin = Factory(:role_admin)
    @messageboard = @admin.messageboard
    @admin_user.roles << @admin
    @admin_user.roles.reload
  end

  describe "#.for(messageboard)" do
    it "filters down roles only for this messagebaord" do
      Role.for(@messageboard).should include(@admin)
    end
  end

  describe "#.as(role)" do
    it "filters down roles only for this particular role" do
      Role.as('admin').should include(@admin)
    end
  end

  describe "#for(messageboard).as(role)" do
    it "filters down roles for this messageboard" do
      Role.for(@messageboard).as('admin').should include(@admin)
    end
  end

  describe "#touch_last_seen(current_user, messageboard)" do
    it "updates last_seen to now" do
      @old_timestamp = @admin.last_seen
      Role.touch_last_seen(@admin_user, @messageboard)
      @admin.reload
      @admin.last_seen.should_not == @old_timestamp
    end
  end

end
