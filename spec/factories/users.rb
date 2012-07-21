FactoryGirl.define do

  sequence(:user_email)       { |n| "user#{n}@example.com" }
  sequence(:user_name)        { |n| "user#{n}" }
  sequence(:other_email) { |n| "other#{n}@email.com" }
  sequence(:other_name)  { |n| "other#{n}" }
  sequence(:password) { |n| "password#{n}" }

  factory :user do
    email              { FactoryGirl.generate(:user_email) }
    name               { FactoryGirl.generate(:user_name) }
    current_sign_in_at 10.minutes.ago
    last_sign_in_at    10.minutes.ago
    current_sign_in_ip '192.168.1.1'
    last_sign_in_ip    '192.168.1.1'
    superadmin         'f'
    time_zone          'Eastern Time (US & Canada)'
    password

    factory :email_confirmed_user do
      email              { FactoryGirl.generate(:user_email) }
      name               { FactoryGirl.generate(:user_name) }
    end

    factory :last_user do
      email              { FactoryGirl.generate(:other_email) }
      name               { FactoryGirl.generate(:other_name) }
    end
  end
end
