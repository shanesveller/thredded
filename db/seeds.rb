# Examples:
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

# remember - to run this ... 
# rake db:seed

m = Messageboard.create( :name => "default", 
                         :description => "this is a default messageboard. you can change this description at any time",
                         :theme => "default",
                         :topic_count => 0,
                         :security => :public  )

t = Topic.create( :user => "admin", :title => "Welcome to your site's very first thread" )
t.messageboard = m
p1 = t.posts.build(:content => "There's not a whole lot here for now.")
p2 = t.posts.build(:content => "So why not do something about it?") 
p1.user = p2.user = "admin"
p1.ip   = p2.ip   = "127.0.0.1"
t.save
 
 
 
 
