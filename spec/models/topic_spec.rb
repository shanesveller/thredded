require 'spec_helper'

describe Topic do

  before(:each) do
    @private_topic = Factory(:topic)
    @public_topic = Factory(:topic)

    @user1 = Factory(:user, :name => "user1")
    @user2 = Factory(:user, :name => "user2")
    @user3 = Factory(:user, :name => "user3")

    @private_topic.users << @user1
    @private_topic.users << @user2
    @private_topic.save
  end

  it "is public by default" do
    @public_topic.public?.should be_true
  end

  it "is private when it has users" do
    @private_topic.private?.should be_true
  end

  context "when it is private" do

    it "does not allow someone not involved to read the topic" do
      pending "need to implement authorization in ability.rb for private threads"
      ability = Ability.new(@user3)
      ability.can?(:read, @private_topic).should be_false
    end

  end

end
