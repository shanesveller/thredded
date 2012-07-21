FactoryGirl.define do
  factory :role do
    level 'admin'
    messageboard

    factory :role_admin do
      level 'admin'
    end

    factory :role_superadmin do
      level 'superadmin'
    end

    factory :role_moderator do
      level 'moderator'
    end

    factory :role_member do
      level 'member'
    end
  end
end
