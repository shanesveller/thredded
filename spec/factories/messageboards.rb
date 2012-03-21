FactoryGirl.define do
  sequence(:messageboard_name)  { |n| "messageboard#{n}"  }
  sequence(:messageboard_title) { |n| "Messageboard #{n}" }

  factory :messageboard do
    name                { FactoryGirl.generate(:messageboard_name) }
    title               { FactoryGirl.generate(:messageboard_title) }
    description         "This is a description of the messageboard"
    theme               'default'
    security            'public'
    posting_permission  'anonymous'
  end
end
