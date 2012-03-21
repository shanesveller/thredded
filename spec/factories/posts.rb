FactoryGirl.define do
  sequence(:content) { |n| "A post about the number #{n}" }

  factory :post do
    user
    topic
    messageboard
    content
    ip          "127.0.0.1"
    filter      'bbcode'
  end
end
