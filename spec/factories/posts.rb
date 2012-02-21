Factory.sequence(:content) {|n| "A post about the number #{n}" }

Factory.define :post do |f|
  f.association :user
  f.association :topic
  f.association :messageboard
  f.content     { Factory.next :content }
  f.ip          "127.0.0.1"
  f.filter      :bbcode
end
