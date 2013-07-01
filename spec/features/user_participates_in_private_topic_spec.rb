require 'spec_helper'

feature 'Private topics' do
  scenario 'can be viewed by me' do
    create(:app_config)
    joel = create_and_log_me_in
    john = create_other_user
    private_topic = PageObject::PrivateTopic.between(joel, john)

    private_topic.create_through_site

    expect(private_topic).to be_listed
    expect(private_topic).to be_readable
    expect(private_topic).to have(1).posts
  end

  scenario 'between others cannot be viewed by me' do
    create(:app_config)
    joel = create_and_log_me_in
    fred = create_other_user('fred')
    sal  = create_other_user('sal')
    private_topic = PageObject::PrivateTopic
      .between(sal, fred)
      .create_with_factory

    expect(private_topic).not_to be_listed
    expect(private_topic).not_to be_readable
  end

  def messageboard
    @messageboard ||= Messageboard.first || create(:messageboard)
  end

  def create_and_log_me_in
    @log_me_in ||= begin
      me = PageObject::User.new.log_in
      me.join(messageboard)
      me
    end
  end

  def create_other_user(name='john')
    user = create(:user, name: name, email: "#{name}@example.com")
    user.member_of(messageboard)
    user
  end
end
