# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :post do |f|
  f.user "MyString"
  f.content "MyString"
  f.ip "MyString"
end
