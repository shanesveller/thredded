# Examples:
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

# remember - to run this ... 
# rake db:seed

Messageboard.create(  :name => "default", 
                      :description => "this is a default messageboard. you can change this description at any time",
                      :theme => "default",
                      :topic_count => 0,
                      :security => :public  )
