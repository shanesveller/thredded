# Examples:
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

# remember - to run this ... 
# rake db:seed

# build first user
u = User.create(:name => "admin",
                :email => "admin@admin.com",
                :password => "admin@admin.com")

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

# build posts
p1 = t.posts.build(:content => "There's not a whole lot here for now.")
p2 = t.posts.build(:content => "So why not do something about it?") 
p1.user = p2.user = u.name
p1.ip   = p2.ip   = "127.0.0.1"
t.save
