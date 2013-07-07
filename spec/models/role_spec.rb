require 'spec_helper'

describe Role, '#.for(messageboard)' do
  it 'filters down roles only for this messagebaord' do
    admin = create(:role, :admin)
    messageboard = admin.messageboard
    expect(Role.for(messageboard)).to include(admin)
  end
end

describe Role, '#.as(role)' do
  it 'filters down roles only for this particular role' do
    superadmin = create(:role, :superadmin)
    messageboard = superadmin.messageboard
    expect(Role.as('superadmin')).to include(superadmin)
  end
end

describe Role, '#for(messageboard).as(role)' do
  it 'filters down roles for this messageboard' do
    moderator = create(:role, :moderator)
    messageboard = moderator.messageboard
    expect(Role.for(messageboard).as('moderator')).to include(moderator)
  end
end
