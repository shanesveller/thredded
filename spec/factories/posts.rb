Factory.define :post do |f|
  f.association :user
  f.association :topic
  f.content "This is a post with great profundity."
  f.ip "127.0.0.1"
  f.filter :bbcode
end
