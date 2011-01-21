Factory.define :messageboard do |f|
  f.sequence(:name) {|n| "messageboard#{n}" }
  f.description "This is a description of the messageboard"
  f.theme "default"
  f.security :public
  f.posting_permission :anonymous
  f.topic_count 0
end
