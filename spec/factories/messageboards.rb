FactoryGirl.define do
  sequence :messageboard_name do |n|
    "messageboard#{n}"
  end
  sequence :messageboard_title do |n|
    "Messageboard #{n}"
  end
end

FactoryGirl.define do
  factory :messageboard do
    name                { FactoryGirl.generate(:messageboard_name) }
    title               { FactoryGirl.generate(:messageboard_title) }
    description         "This is a description of the messageboard"
    theme               'default'
    security            'public'
    posting_permission  'anonymous'
  end
end
