require 'spec_helper'

describe User, 'associations' do
  it { should have_many(:preferences) }
  it { should have_many(:identities) }
  it { should eager_load(:roles) }
end

describe User, '.recently_active_in' do
  it 'returns users who were active as of 5 minutes ago' do
    messageboard = create(:messageboard)
    phil = create(:role, :inactive, messageboard: messageboard)
    tom = create(:role, messageboard: messageboard, last_seen: 1.minute.ago)
    joel = create(:role, messageboard: messageboard, last_seen: 2.minutes.ago)
    active_users = User.recently_active_in(messageboard)

    expect(active_users).to include(joel.user)
    expect(active_users).to include(tom.user)
    expect(active_users).not_to include(phil.user)
  end
end

describe User, '#from_omniauth' do
  let(:auth_github) {
    {
      'provider' => 'github',
      'uid' => '123',
      'info' => {
        'nickname' => 'jayroh',
        'email' => 'joel@example.com',
      }
    }
  }

  it 'finds user when they exist' do
    user = create(:user, email: 'joel@example.com')

    User.from_omniauth(auth_github).should eq user
  end

  it 'creates a user when they do not exist yet' do
    user = User.from_omniauth(auth_github)

    user.should be_valid
    user.should be_persisted
    user.name.should eq 'jayroh'
  end
end

describe User, '#at_notifications_for?' do
  it 'is true for those without any preference' do
    user = build_stubbed(:user)
    messageboard = build_stubbed(:messageboard)

    expect(user.at_notifications_for?(messageboard)).to eq true
  end

  it 'is false for those who un-check it in their preferences' do
    preference = create(:preference, notify_on_mention: false)
    user = preference.user
    messageboard = preference.messageboard

    expect(user.at_notifications_for?(messageboard)).to eq false
  end

  it 'is true for those who check it in their preferences' do
    preference = build_stubbed(:preference, notify_on_mention: true)
    user = preference.user
    messageboard = preference.messageboard

    expect(user.at_notifications_for?(messageboard)).to eq true
  end
end

describe User do
  describe '.mark_active_in!' do
    it 'updates last_seen to now' do
      @now_time = Time.local(2011, 9, 1, 12, 0, 0)
      @messageboard = create(:messageboard)
      @user = create(:user)
      @user.member_of @messageboard

      Timecop.freeze(@now_time) do
        @user.mark_active_in!(@messageboard)
        @user.roles.for(@messageboard).first.last_seen.should eq @now_time
      end
    end
  end

  describe '#admins?(messageboard)' do
    it 'returns true for an admin' do
      admin = create(:role, :admin)
      stu = admin.user
      messageboard = admin.messageboard

      expect(stu.admins?(messageboard)).to eq true
    end

    it 'returns true for a superadmin' do
      joel = build_stubbed(:user, :superadmin)
      messageboard = build_stubbed(:messageboard)

      expect(joel.admins?(messageboard)).to eq true
    end

    it 'returns false for carl' do
      carl = build_stubbed(:user)
      messageboard = build_stubbed(:messageboard)

      expect(carl.admins?(messageboard)).to eq false
    end
  end

  describe '#superadmin?' do
    it 'checks that a superadmin can manage everything' do
      joel = build_stubbed(:user, superadmin: true)

      expect(joel.superadmin?).to eq true
    end

    it 'makes sure a regular user cannot' do
      carl = build_stubbed(:user)

      expect(carl.superadmin?).to eq false
    end
  end

  describe '#moderates?(messageboard)' do
    it 'returns true for a moderator' do
      moderator = create(:role, :moderator)
      norah = moderator.user
      messageboard = moderator.messageboard

      expect(norah.moderates?(messageboard)).to eq true
    end

    it 'returns false for joel' do
      joel = create(:user, email: 'joel@joel.com', name: 'joel')
      messageboard = create(:messageboard)

      expect(joel.moderates?(messageboard)).to eq false
    end
  end

  describe '#member_of?(messageboard)' do
    it 'returns true for a member' do
      member = create(:role, :member)
      messageboard = member.messageboard
      john = member.user

      expect(john.member_of?(messageboard)).to eq true
    end
  end

  describe '#member_of(messageboard)' do
    it 'sets the user as a member of messageboard' do
      tam = create(:user)
      messageboard = create(:messageboard)
      tam.member_of(messageboard)
      tam.reload

      expect(tam.member_of?(messageboard)).to eq true
    end

    it 'makes the user an admin' do
      stephen = create(:user)
      messageboard = create(:messageboard)
      stephen.member_of(messageboard, 'admin')
      stephen.reload

      stephen.admins?(messageboard).should eq true
    end
  end

  describe '#after_save' do
    it 'will update posts.user_email' do
      shaun = create(:user, name: 'shaun', email: 'shaun@example.com')
      post  = create(:post, user: shaun)
      post.save

      shaun.email = 'boffe@example.com'
      shaun.save

      post.reload
      post.user_email.should eq shaun.email
    end
  end

  describe '.email' do
    it 'will be valid' do
      shaun = build_stubbed(:user, email: 'shaun@example.com')
      shaun.should be_valid
    end

    it 'will not be valid' do
      shaun = build_stubbed(:user, email: 'shaun.com')
      shaun.should_not be_valid
    end
  end
end
