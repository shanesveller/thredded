Factory.define :post, :class => Post, :default_strategy => :build do |f|
  f.user "username"
  f.content "This is a post by someone called ... originally enough .. 'username'"
  f.ip "127.0.0.1"
  f.filter :bbcode
end
