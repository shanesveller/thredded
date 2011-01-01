require 'timecop'
# Examples:
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

# remember - to run this ... 
# rake db:seed

# build first user
u = User.new(:name => "admin",
                :email => "admin@admin.com",
                :password => "admin@admin.com")
u.superadmin = true
u.save

# build messagebaord
m = Messageboard.create( :name => "default", 
                         :description => "this is a default messageboard. you can change this description at any time",
                         :theme => "default",
                         :topic_count => 0,
                         :security => :public,
                         :posting_permission => :anonymous)
# make u a member of m
u.messageboards << m
u.save


# build topic
t = Topic.create( :user => "admin", :title => "Welcome to your site's very first thread" )
t.messageboard = m
# build post for first topic
p1 = t.posts.create(:content => "There's not a whole lot here for now.", :user => "joel", :ip => "127.0.0.1")

# **********************************
Timecop.travel(Time.now.advance(:seconds => 10))
# **********************************

# build another topic
t2 = Topic.create( :user => "joel", :title => "Another example topic" )
t2.messageboard = m
# post for the second topic
p2 = t2.posts.create(:content => "Lorem ipsum jibba jabba small talk how's the weather there lol?", :user => "joel", :ip => "127.0.0.1")

# **********************************
Timecop.travel(Time.now.advance(:seconds => 20))
# **********************************

# let's bump the first topic so it's @ top
p3 = t.posts.create(:content => "So why not do something about it?", :user => "sara", :ip => "127.0.0.1") 