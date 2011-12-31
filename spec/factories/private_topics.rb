Factory.define :private_topic do |f|
  f.title "New private topic started here"
  f.association :user
  f.association :last_user
  f.association :messageboard
end
