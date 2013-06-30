require 'spec_helper'
require 'cancan/matchers'

describe User, 'abilities' do
  let(:user) { User.new }

  context 'for a private messageboard' do
    let(:messageboard) { create(:messageboard, :private) }

    it 'allows members to view it' do
      user = create(:user)
      messageboard.add_member(user)
      ability = Ability.new(user)
      ability.should be_able_to(:read, messageboard)
    end

    it 'does not allow a non-members to view it' do
      user = create(:user)
      ability = Ability.new(user)
      ability.should_not be_able_to(:read, messageboard)
    end

    it 'does not allow anonymous to view it' do
      user = NullUser.new
      ability = Ability.new(user)
      ability.should_not be_able_to(:read, messageboard)
    end
  end

  context 'for a new post' do
    context 'in a logged-in-only messageboard' do
      it 'can be created by someone logged in' do
        user = create(:user)
        messageboard = create(:messageboard, :logged_in)
        topic = create(:topic, user: user, messageboard: messageboard)
        post = build(:post, user: user, topic: topic)
        ability = Ability.new(user)

        ability.should be_able_to(:create, post)
      end

      it 'cannot be created by an anonymous user' do
        user = NullUser.new
        messageboard = create(:messageboard, :logged_in)
        topic = create(:topic, messageboard: messageboard)
        post = build(:post, topic: topic)
        ability = Ability.new(user)

        ability.should_not be_able_to(:create, post)
      end
    end

    it 'can be created in an unlocked topic' do
      user = create(:user)
      messageboard = create(:messageboard, :logged_in)
      topic = create(:topic, :unlocked, user: user, messageboard: messageboard)
      post = build(:post, user: user, topic: topic)
      ability = Ability.new(user)

      ability.should be_able_to(:create, post)
    end

    it 'cannot be created in a locked topic' do
      user = create(:user)
      topic = create(:topic, :locked, user: user)
      post = build(:post, user: user, topic: topic)
      ability = Ability.new(user)

      ability.should_not be_able_to(:create, post)
    end
  end

  context 'for a topic' do
    it 'allows a user to read it' do
      topic = build_stubbed(:topic)
      ability = Ability.new(build_stubbed(:user))
      ability.should be_able_to(:read, topic)
    end

    context 'in a messageboard with logged_in permissions' do
      before(:each) do
        @user = create(:user)
        @messageboard = create(:messageboard, :restricted_to_logged_in)
        @topic  = create(:topic, messageboard: @messageboard)
      end

      it 'is not readable by anonymous visitors' do
        @user = NullUser.new
        ability = Ability.new(@user)
        ability.can?(:read, @topic).should be_false
      end

      it 'is readable by a logged in user' do
        ability = Ability.new(@user)
        ability.can?(:read, @topic).should be_true
      end
    end

    context 'in a private messageboard' do
      before do
        @messageboard = build_stubbed(:messageboard, security: 'private')
        @topic = build_stubbed(:topic, messageboard: @messageboard)
        @user = build_stubbed(:user)
      end

      it 'allows a member to create a topic' do
        @messageboard.stubs(has_member?: true)
        ability = Ability.new(@user)
        ability.should be_able_to(:create, @topic)
      end

      it 'allows a member to read a topic' do
        @messageboard.stubs(has_member?: true)
        ability = Ability.new(@user)
        ability.should be_able_to(:read, @topic)
      end

      it 'does not allow a non-member to read a topic' do
        @messageboard.stubs(has_member?: false)
        ability = Ability.new(@user)
        ability.should_not be_able_to(:read, @topic)
      end

      it 'does not allow a non-member to create a topic' do
        @messageboard.stubs(has_member?: false)
        ability = Ability.new(@user)
        ability.should_not be_able_to(:create, @topic)
        ability.should_not be_able_to(:create, Topic.new)
      end

      it 'does not allow a logged in user to create a topic' do
        @messageboard.stubs(has_member?: false)
        ability = Ability.new(@user)
        ability.should_not be_able_to(:create, @topic)
      end

      it 'does not allow a logged in user to read a topic' do
        @messageboard.stubs(has_member?: false)
        ability = Ability.new(@user)
        ability.should_not be_able_to(:create, @topic)
      end

      it 'does not allow a logged in user to list topics' do
        @messageboard.stubs(has_member?: false)
        ability = Ability.new(@user)
        ability.should_not be_able_to(:index, @topic)
      end

      it 'does not allow anonymous to create a topic' do
        @user = User.new
        ability = Ability.new(@user)
        ability.should_not be_able_to(:create, @topic)
      end

      it 'does not allow anonymous to read a topic' do
        @user = User.new
        ability = Ability.new(@user)
        ability.should_not be_able_to(:read, @topic)
      end
    end
  end

  context 'for listing of private topics' do
    it 'will not allow someone with no private messages' do
      user = build_stubbed(:user, private_topics: [])
      ability = Ability.new(user)

      ability.should_not be_able_to(:read, PrivateTopic.new)
    end

    it 'will allow someone with private messages to list them' do
      user = stubs(:user)
      user.stubs(private_topics: ['shh'], superadmin?: false)
      ability = Ability.new(user)

      ability.should be_able_to(:read, PrivateTopic.new)
    end
  end

  context 'for a private topic' do
    it 'allows an involved user to read it' do
      user = build_stubbed(:user)
      ability = Ability.new(user)
      private_topic = build_stubbed(:private_topic, users: [user])
      ability.should be_able_to(:read, private_topic)
    end

    it 'does not allow a random user to read it' do
      random_user = build_stubbed(:user, name: 'joe')
      user = build_stubbed(:user)
      ability = Ability.new(random_user)
      private_topic = build_stubbed(:private_topic, users: [user])
      ability.should_not be_able_to(:read, private_topic)
    end

    it 'does not allow an admin to read it' do
      user = build_stubbed(:user)
      admin = build_stubbed(:user)
      admin.stubs(admins?: true)
      ability = Ability.new(admin)
      private_topic = build_stubbed(:private_topic, users: [user])

      ability.should_not be_able_to(:manage, private_topic)
      ability.should_not be_able_to(:read, private_topic)
    end
  end
end
