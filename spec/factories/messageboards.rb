FactoryGirl.define do
  sequence(:name)  { |n| "messageboard#{n}"  }
  sequence(:title) { |n| "Messageboard #{n}" }

  factory :messageboard do
    name
    title
    description         "This is a description of the messageboard"
    theme               'default'
    security            'public'
    posting_permission  'anonymous'
  end
end
