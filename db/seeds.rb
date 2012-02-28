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
m = Messageboard.create!( :name => "default", 
                         :title => 'Default',
                         :description => "this is a default messageboard. you can change this description at any time",
                         :theme => "default",
                         :topics_count => 0,
                         :security => 'public',
                         :posting_permission => 'anonymous')
# make u a member of m
Role.create!(:messageboard_id => m.id, :user_id => u.id, :level => 'superadmin')


# build topic
t = Topic.create!( :user => u, 
                  :title => "Welcome to your site's very first thread", 
                  :messageboard => m,
                  :last_user => u )
# build post for first topic
p1 = t.posts.create(:content => "There's not a whole lot here for now.", :user => u, :ip => "127.0.0.1")

# **********************************
Timecop.travel(Time.now.advance(:seconds => 10))
# **********************************

# build another topic
t2 = Topic.create!( :user => u, 
                  :title => "Another example topic", 
                  :messageboard => m,
                  :last_user => u )
t2.messageboard = m
# post for the second topic
p2 = t2.posts.create(:content => "Lorem ipsum jibba jabba small talk how's the weather there lol?", :user => u, :ip => "127.0.0.1")

# **********************************
Timecop.travel(Time.now.advance(:seconds => 20))
# **********************************

# let's bump the first topic so it's @ top
p3 = t.posts.create(:content => "So why not do something about it?", :user => u, :ip => "127.0.0.1") 
