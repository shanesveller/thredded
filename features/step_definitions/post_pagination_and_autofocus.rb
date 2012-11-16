Given /^posts are paginated every (\d+) posts$/ do |post_num|
  Post.paginates_per post_num.to_i
end

Given /^the latest thread on "([^"]*)" has (\d+) posts$/ do |name, post_num|
  board = Messageboard.find_by_name(name)
  @topic = create(:topic, messageboard: board)

  post_num.to_i.times do
    create(:post, topic: @topic, messageboard: board)
  end
end

Then /^the latest read post should be the (first|fifth|sixth) post$/ do |post_index|
  case post_index
  when 'first'
    post = @topic.posts.first
  when 'fifth'
    post = @topic.posts[4]
  when
    post = @topic.posts[5]
  end

  page.should have_css("body[data-latest-read='#{post.id}']")
  page.should have_css("article#post_#{post.id}")
end

When /^I click to page (\d+) and view the latest post$/ do |page_num|
  within :css, 'footer .pagination' do
    click_link page_num
  end
end

When /^(\d+) more people post on the latest thread$/ do |reply_num|
  reply_num.to_i.times do
    create(:post, topic: @topic, messageboard: @topic.messageboard, user: User.first)
  end
end

Then /^I should see (\d+) posts$/ do |post_num|
  page.should have_css('article.post', count: post_num.to_i)
end

Then /^I should see page (\d+)$/ do |page_num|
  page.should have_css('.page.current', text: page_num)
end
