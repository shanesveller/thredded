Factory.define :topic do |t|
  t.permission :public
  t.user "admin"
  t.last_user "admin"
  t.title "Topic started by the admin"
  t.post_count 1

  # t.association :posts, :factory => :post
end
