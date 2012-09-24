require 'spec_helper'

describe Post do
  it { should validate_presence_of :content }
  it { should validate_presence_of :messageboard_id }

  describe "#create" do
    before(:each) do
      @shaun = create(:user)
      @joel  = create(:user)
      @topic = create(:topic, last_user: @shaun)
      @post  = create(:post)
      @messageboard = @topic.messageboard
    end

    after(:each) do
      Timecop.return
    end

    it "updates the parent topic with the latest post author" do
      @post = build(:post, user: @joel, topic: @topic)
      @post.save
      @topic.reload.last_user.should == @joel
    end

    it "increments the topic's and user's post counts" do
      3.times do
        @topic.posts.create!(user: @joel, last_user: @joel, content: "content",
          messageboard: @messageboard)
      end
      @topic.reload.posts_count.should == 3
      @joel.reload.posts_count.should  == 3
    end

    it "updates the topic updated_at field to that of the new post" do
      @topic.posts.create(user: @joel, content: "posting here",
        messageboard: @messageboard)
      @topic.posts.create(user: @joel, content: "posting more",
        messageboard: @messageboard)
      last_post = @topic.posts.last
      @topic.updated_at.should be_within(2.seconds).of(last_post.created_at)
    end

    it "sets the post user's email on creation" do
      @new_post = Post.create(user: @shaun, topic: @topic,
        messageboard: @messageboard, content: "this is a post from shaun",
        ip: "255.255.255.0", filter: "bbcode")

      @new_post.user_email.should == @new_post.user.email
    end
  end

  describe ".filtered_content" do
    before(:each) do
      @post  = build(:post)
    end

    it "converts textile to html" do
      @post.content = "this is *bold*"
      @post.filter = "textile"
      @post.filtered_content.should == "<p>this is <strong>bold</strong></p>"
    end

    it "converts bbcode to html" do
      @post.content = "this is [b]bold[/b]"
      @post.filter = "bbcode"
      @post.filtered_content.should == "this is <strong>bold</strong>"
    end

    it "performs some syntax highlighting with bbcode" do
      @post.content = "[code]def hello
  puts 'world'
end[/code]

[code:javascript]function(){ 
  console.log('hi'); 
}[/code]"
      @post.filter = "bbcode"
      @post.filtered_content.should == "<div class=\"CodeRay\">\n  <div class=\"code\"><pre><span class=\"keyword\">def</span> <span class=\"function\">hello</span>\n  puts <span class=\"string\"><span class=\"delimiter\">'</span><span class=\"content\">world</span><span class=\"delimiter\">'</span></span>\n<span class=\"keyword\">end</span></pre></div>\n</div>\n<br />\n<br />\n<div class=\"CodeRay\">\n  <div class=\"code\"><pre><span class=\"keyword\">function</span>(){ \n  console.log(<span class=\"string\"><span class=\"delimiter\">'</span><span class=\"content\">hi</span><span class=\"delimiter\">'</span></span>); \n}</pre></div>\n</div>\n"
    end

    it "converts markdown to html" do
      @post.content = "# Header\nhttp://www.google.com"
      @post.filter = "markdown"
      @post.filtered_content.should == "<h1>Header</h1>\n\n<p><a href=\"http://www.google.com\">http://www.google.com</a></p>\n"
    end

    it "performs some syntax highlighting in markdown" do
      @post.content = "this is code

    def hello; puts 'world'; end

right here"
      @post.filter = "markdown"
      @post.filtered_content.should == "<p>this is code</p>\n\n<div class=\"CodeRay\">\n  <div class=\"code\"><pre><span class=\"keyword\">def</span> <span class=\"function\">hello</span>; puts <span class=\"string\"><span class=\"delimiter\">'</span><span class=\"content\">world</span><span class=\"delimiter\">'</span></span>; <span class=\"keyword\">end</span>\n</pre></div>\n</div>\n\n\n<p>right here</p>\n"
    end

    it "translates psuedo-image tags to html" do
      @post.content = "[t:img=2 left] [t:img=3 right] [t:img] [t:img=4 200x200]"
      @post.save
      @attachment_4 = FactoryGirl.create(:zippng,     :post => @post) # 4 zip
      @attachment_3 = FactoryGirl.create(:txtpng,     :post => @post) # 3 txt
      @attachment_2 = FactoryGirl.create(:pdfpng,     :post => @post) # 2 pdf
      @attachment_1 = FactoryGirl.create(:attachment, :post => @post) # 1 img 

      expectation = "<img src=\"/uploads/attachment/#{@attachment_2.id}/pdf.png\" class=\"align_left\" /> <img src=\"/uploads/attachment/#{@attachment_3.id}/txt.png\" class=\"align_right\" /> <img src=\"/uploads/attachment/#{@attachment_1.id}/img.png\" /> <img src=\"/uploads/attachment/#{@attachment_4.id}/zip.png\" width=\"200\" height=\"200\" />"

      @post.filtered_content.should == expectation
    end
  end
end
