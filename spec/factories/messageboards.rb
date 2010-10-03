# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :messageboard do |f|
  f.name "MyString"
  f.description "MyString"
  f.theme "MyString"
  f.security "MyString"
  f.topic_count 1
end
