# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :topic do |f|
  f.permission "MyString"
  f.user "MyString"
  f.last_user "MyString"
  f.title "MyString"
  f.post_count 1
end
