require 'spec_helper'

describe Post do
  it { should validate_presence_of :content }
  it { should validate_presence_of :messageboard_id }

  describe '#create' do
    after(:each) do
      Timecop.return
    end

    it 'updates the parent topic with the latest post author' do
      joel  = create(:user)
      topic = create(:topic)
      post = create(:post, user: joel, topic: topic)

      topic.reload.last_user.should == joel
    end

    it "increments the topic's and user's post counts" do
      joel  = create(:user)
      topic = create(:topic)

      3.times do
        topic.posts.create!(user: joel, last_user: joel, content: 'content',
          messageboard: topic.messageboard)
      end

      topic.reload.posts_count.should == 3
      joel.reload.posts_count.should  == 3
    end

    it 'updates the topic updated_at field to that of the new post' do
      joel  = create(:user)
      topic = create(:topic)
      topic.posts.create(user: joel, content: "posting here",
        messageboard: topic.messageboard)
      topic.posts.create(user: joel, content: "posting more",
        messageboard: topic.messageboard)
      last_post = topic.posts.last

      topic.updated_at.should be_within(2.seconds).of(last_post.created_at)
    end

    it "sets the post user's email on creation" do
      shaun = create(:user)
      topic = create(:topic, last_user: shaun)

      new_post = Post.create(user: shaun,
        topic: topic,
        messageboard: topic.messageboard,
        content: 'this is a post from shaun',
        ip: '255.255.255.0',
        filter: 'bbcode')

      new_post.user_email.should == new_post.user.email
    end
  end

  describe '.filtered_content' do
    before(:each) do
      @post  = build(:post)
    end

    it 'converts textile to html' do
      @post.content = 'this is *bold*'
      @post.filter = 'textile'
      @post.filtered_content.should == '<p>this is <strong>bold</strong></p>'
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
      @post.filtered_content.should == "<div class=\"CodeRay\">\n  <div class=\"code\"><pre><span class=\"keyword\">def</span> <span class=\"function\">hello</span>\n  puts <span class=\"string\"><span class=\"delimiter\">'</span><span class=\"content\">world</span><span class=\"delimiter\">'</span></span>\n<span class=\"keyword\">end</span></pre></div>\n</div>\n<br />\n<br />\n<div class=\"CodeRay\">\n  <div class=\"code\"><pre><span class=\"keyword\">function</span>(){\n  console.log(<span class=\"string\"><span class=\"delimiter\">'</span><span class=\"content\">hi</span><span class=\"delimiter\">'</span></span>);\n}</pre></div>\n</div>\n"
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
      @post.filter = 'markdown'
      @post.filtered_content.should == "<p>this is code</p>\n\n<div class=\"CodeRay\">\n  <div class=\"code\"><pre><span class=\"keyword\">def</span> <span class=\"function\">hello</span>; puts <span class=\"string\"><span class=\"delimiter\">'</span><span class=\"content\">world</span><span class=\"delimiter\">'</span></span>; <span class=\"keyword\">end</span>\n</pre></div>\n</div>\n\n\n<p>right here</p>\n"
    end

    it "translates psuedo-image tags to html" do
      attachment_1 = build_stubbed(:imgpng)
      attachment_2 = build_stubbed(:pdfpng)
      attachment_3 = build_stubbed(:txtpng)
      attachment_4 = build_stubbed(:zippng)
      attachment_1.stubs(id: '4', attachment: '/uploads/attachment/4/img.png')
      attachment_2.stubs(id: '3', attachment: '/uploads/attachment/3/pdf.png')
      attachment_3.stubs(id: '2', attachment: '/uploads/attachment/2/txt.png')
      attachment_4.stubs(id: '1', attachment: '/uploads/attachment/1/zip.png')

      post = build_stubbed(:post,
        content: '[t:img=2 left] [t:img=3 right] [t:img] [t:img=4 200x200]',
        attachments: [attachment_1, attachment_2, attachment_3, attachment_4])

      expectation = "<img src=\"/uploads/attachment/3/pdf.png\" class=\"align_left\" /> <img src=\"/uploads/attachment/2/txt.png\" class=\"align_right\" /> <img src=\"/uploads/attachment/4/img.png\" /> <img src=\"/uploads/attachment/1/zip.png\" width=\"200\" height=\"200\" />"

      post.filtered_content.should == expectation
    end

    it 'links @names of members' do
      Messageboard.any_instance.stubs(members_from_list: %w{sam joe})
      post = build_stubbed(:post,
        content: 'for @sam but not @al or @kek. And @joe.')
      expectation = 'for <a href="/users/sam">@sam</a> but not @al or @kek. And <a href="/users/joe">@joe</a>.'

      post.filtered_content.should eq expectation
    end
  end
end
