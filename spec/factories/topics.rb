FactoryGirl.define do
  factory :topic do
    title "New topic started here"
    user
    association :last_user, :factory => :user
    messageboard
  end
end
