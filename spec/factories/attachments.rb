# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :attachment do |f|
  f.attachment "MyString"
  f.post_id 1
  f.content_type "MyString"
  f.file_size 1
end