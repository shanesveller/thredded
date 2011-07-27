Factory.define :topic do |f|
  f.title "New topic started here"
  f.association :user
  f.association :messageboard
end
