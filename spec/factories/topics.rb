Factory.define :topic do |t|
  t.permission :public
  t.title "New topic started here"
  t.post_count 1
  t.association :user
  t.association :messageboard
  # t.association :last_user
  # t.association :posts, :factory => :post
end
