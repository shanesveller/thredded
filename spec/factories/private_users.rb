# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :private_user do |f|
  f.private_topic_id 1
  f.user_id 1
end