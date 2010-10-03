Factory.define :messageboard do |f|
  f.name "default"
  f.description "This is a description of the messageboard"
  f.theme "default"
  f.security :public
  f.topic_count 0
end
