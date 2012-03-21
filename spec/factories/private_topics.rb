FactoryGirl.define do 
  factory :private_topic do
    title "New private topic started here"
    user
    association :last_user, :factory => :user
    messageboard
  end
end
