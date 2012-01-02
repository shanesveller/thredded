# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :setting do |f|
  f.site_name "MyString"
  f.site_slug "MyString"
  f.email_reply_to "MyString"
  f.email_subject_prefix "MyString"
  f.domain "MyString"
end