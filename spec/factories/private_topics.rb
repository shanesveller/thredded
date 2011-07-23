Factory.define :private_topic do |f|
  f.association :user
  f.association :messageboard
end
