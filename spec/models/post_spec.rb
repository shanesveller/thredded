require 'spec_helper'

describe Post, 'validations' do
  it { should validate_presence_of(:content) }
  it { should validate_presence_of(:messageboard_id) }
  it { should validate_presence_of(:user_id) }
end

describe Post, 'associations' do
  it { should have_many(:post_notifications) }
  it { should have_many(:attachments) }
  it { should belong_to(:user) }
  it { should belong_to(:topic) }
  it { should belong_to(:messageboard) }
end

describe Post, '#create' do
  before(:each) do
    Time.zone = 'UTC'
    Chronic.time_class = Time.zone
  end

  after(:each) do
    Timecop.return
  end

  it 'Notifies @ users', :notifiers do
    notifier = mock('notifier')
    notifier.stubs(notifications_for_at_users: true)
    AtNotifier.stubs(new: notifier)

    post = create(:post)

    expect(AtNotifier).to have_received(:new).with(post)
    expect(notifier).to have_received(:notifications_for_at_users)
  end

  it 'updates the parent topic with the latest post author' do
    joel  = create(:user)
    topic = create(:topic)
    post = create(:post, user: joel, topic: topic)

    expect(topic.reload.last_user).to eq joel
  end

  it 'increments the topic and user post counts' do
    joel  = create(:user)
    topic = create(:topic)
    create_list(:post, 3,
      topic: topic,
      user: joel,
      messageboard: topic.messageboard,
    )

    expect(topic.reload.posts_count).to eq 3
    expect(joel.reload.posts_count).to eq 3
  end

  it 'updates the topic updated_at field to that of the new post' do
    joel  = create(:user)
    topic = create(:topic)
    messageboard = topic.messageboard
    noontime = Chronic.parse('Jan 1st 2012 at noon')
    three_pm = Chronic.parse('Jan 1st 2012 at 3pm')

    Timecop.travel(noontime) do
      create(:post,
        topic: topic,
        messageboard: messageboard,
        user: joel
      )
    end

    Timecop.travel(three_pm) do
      create(:post,
        topic: topic,
        messageboard: messageboard,
        user: joel
      )
    end

    expect(topic.updated_at.to_s).to eq three_pm.to_s
  end

  it 'sets the post user email on creation' do
    shaun = create(:user, email: 'shaun@example.com')
    topic = create(:topic, last_user: shaun)
    post = create(:post, user: shaun, topic: topic)

    expect(post.user_email).to eq 'shaun@example.com'
  end
end

describe Post, '.filtered_content' do
  before(:each) do
    @post  = build(:post)
  end

  it 'renders implied legacy links' do
    @post.content = 'go to [link]http://google.com[/link]'
    @post.filter = 'bbcode'

    @post.filtered_content.should eq 'go to <a href="http://google.com">http://google.com</a>'
  end

  it 'renders legacy links' do
    @post.content = 'let me [link=http://google.com]google[/link] that'
    @post.filter = 'bbcode'

    @post.filtered_content.should eq 'let me <a href="http://google.com">google</a> that'
  end

  it 'converts textile to html' do
    @post.content = 'this is *bold*'
    @post.filter = 'textile'
    @post.filtered_content.should eq '<p>this is <strong>bold</strong></p>'
  end

  it 'converts bbcode to html' do
    @post.content = 'this is [b]bold[/b]'
    @post.filter = 'bbcode'
    @post.filtered_content.should eq 'this is <strong>bold</strong>'
  end

  it 'handles quotes' do
    @post.content = '[quote]hi[/quote] [quote="john"]hey[/quote]'
    @post.filter = 'bbcode'
    expected_output = '</p><fieldset><blockquote><p>hi</p></blockquote></fieldset><fieldset><legend>"john"</legend><blockquote><p>hey</p></blockquote></fieldset><p>'
    @post.filtered_content.should eq expected_output
  end

  it 'handles nested quotes' do
    @post.content = '[quote=joel][quote=john]hello[/quote] hi[/quote]'
    @post.filter = 'bbcode'
    expected_output = '</p><fieldset><legend>joel</legend><blockquote><fieldset><legend>john</legend><blockquote><p>hello</p></blockquote></fieldset><p> hi</p></blockquote></fieldset><p>'
    @post.filtered_content.should eq expected_output
  end

  it 'performs specific syntax highlighting with bbcode' do
    input = <<-EOCODE.strip_heredoc
      [code:ruby]def hello
      puts 'world'
      end[/code]

      [code:javascript]function(){
      console.log('hi');
      }[/code]
    EOCODE

    expected_output = %Q(<div class="CodeRay">\n  <div class="code"><pre><span class="keyword">def</span> <span class="function">hello</span>\nputs <span class="string"><span class="delimiter">'</span><span class="content">world</span><span class="delimiter">'</span></span>\n<span class="keyword">end</span></pre></div>\n</div>\n<br />\n<br />\n<div class="CodeRay">\n  <div class="code"><pre><span class="keyword">function</span>(){\nconsole.log(<span class="string"><span class="delimiter">'</span><span class="content">hi</span><span class="delimiter">'</span></span>);\n}</pre></div>\n</div>\n<br />\n)

    @post.filter = 'bbcode'
    @post.content = input

    @post.filtered_content.should eq expected_output
  end

  it 'performs specific syntax highlighting with bbcode' do
    input = <<-EOCODE.strip_heredoc
      [code:javascript]function(){
      console.log('hi');
      }[/code]

      that was code
    EOCODE

    expected_output = %Q(<div class="CodeRay">\n  <div class="code"><pre><span class="keyword">function</span>(){\nconsole.log(<span class="string"><span class="delimiter">'</span><span class="content">hi</span><span class="delimiter">'</span></span>);\n}</pre></div>\n</div>\n<br />\n<br />\nthat was code<br />\n)

    @post.filter = 'bbcode'
    @post.content = input

    @post.filtered_content.should eq expected_output
  end

  it 'converts markdown to html' do
    @post.content = "# Header\nhttp://www.google.com"
    @post.filter = 'markdown'

    @post.filtered_content.should eq %Q(<h1>Header</h1>\n\n<p><a href="http://www.google.com">http://www.google.com</a></p>\n)
  end

  it 'performs some syntax highlighting in markdown' do
    input = "this is code

    def hello; puts 'world'; end

right here"

    expected_output = "<p>this is code</p>\n\n<div class=\"CodeRay\">\n  <div class=\"code\"><pre><span class=\"keyword\">def</span> <span class=\"function\">hello</span>; puts <span class=\"string\"><span class=\"delimiter\">'</span><span class=\"content\">world</span><span class=\"delimiter\">'</span></span>; <span class=\"keyword\">end</span>\n</pre></div>\n</div>\n\n\n<p>right here</p>\n"

    @post.content = input
    @post.filter = 'markdown'

    @post.filtered_content.should eq expected_output
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
    sam = build_stubbed(:user, name: 'sam')
    joe = build_stubbed(:user, name: 'joe')
    Messageboard.any_instance.stubs(members_from_list: [sam, joe])
    post = build_stubbed(:post, content: 'for @sam but not @al or @kek. And @joe.')
    expectation = 'for <a href="/users/sam">@sam</a> but not @al or @kek. And <a href="/users/joe">@joe</a>.'

    post.filtered_content.should eq expectation
  end
end
