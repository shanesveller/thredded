FactoryGirl.define do
  factory :role do
    messageboard
    level         'admin' # so I don't break current tests

    factory :role_admin do
      level         'admin'
    end

    factory :role_superadmin do
      level         'superadmin'
    end

    factory :role_moderator do
      level         'moderator'
    end

    factory :role_member do
      level         'member'
    end

  end
end
