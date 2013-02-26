require 'spec_helper'

describe SearchSqlBuilder, 'build' do
  before do
    @messageboard = create(:messageboard)
    @joel = create(:user, name: 'joel')
    @shaun = create(:user, name: 'shaun')

    @topic1 = create(:topic, messageboard: @messageboard,
                    title: 'Joel made a topic', user: @joel, with_categories: 1)
    @topic2 = create(:topic, messageboard: @messageboard,
                    title: 'Shaun made a topic', user: @shaun, with_categories: 1)
    @topic3 = create(:topic, messageboard: @messageboard,
                    title: 'Shaun created another topic', user: @shaun, with_categories: 1)

    @topic1.posts.create!(messageboard: @messageboard, content: 'spring board cats', user: @joel)
    @topic2.posts.create!(messageboard: @messageboard, content: 'alpine spring is very refreshing', user: @shaun)
    @topic3.posts.create!(messageboard: @messageboard, content: 'some other topic content', user: @shaun)
  end

  it 'finds results for a text search' do
    search_query = ' spring '
    Topic.full_text_search(search_query, @messageboard).should include(@topic1)
    Topic.full_text_search(search_query, @messageboard).should include(@topic2)
    Topic.full_text_search(search_query, @messageboard).should_not include(@topic3)

    search_query = '"alpine spring"'
    Topic.full_text_search(search_query, @messageboard).should include(@topic2)
    Topic.full_text_search(search_query, @messageboard).should_not include(@topic1)
    Topic.full_text_search(search_query, @messageboard).should_not include(@topic3)
  end

  it 'finds 1 result with similar posts in different categories' do
    search_query = "spring in:#{@topic1.categories[0].name}"
    Topic.full_text_search(search_query, @messageboard).should include(@topic1)
    Topic.full_text_search(search_query, @messageboard).should_not include(@topic2)
    Topic.full_text_search(search_query, @messageboard).should_not include(@topic3)
  end

  it 'finds 1 result with similar posts by different users' do
    search_query = 'spring by:shaun'
    Topic.full_text_search(search_query, @messageboard).should include(@topic2)
    Topic.full_text_search(search_query, @messageboard).should_not include(@topic1)
    Topic.full_text_search(search_query, @messageboard).should_not include(@topic3)
  end

  it 'finds results with more than one specified category' do
    search_query = "in:#{@topic1.categories[0].name} in:#{@topic2.categories[0].name}"
    Topic.full_text_search(search_query, @messageboard).should include(@topic1)
    Topic.full_text_search(search_query, @messageboard).should include(@topic2)
    Topic.full_text_search(search_query, @messageboard).should_not include(@topic3)
  end

  it 'finds results with more than one specified user' do
    search_query = 'spring by:shaun by:joel'
    Topic.full_text_search(search_query, @messageboard).should include(@topic1)
    Topic.full_text_search(search_query, @messageboard).should include(@topic2)
    Topic.full_text_search(search_query, @messageboard).should_not include(@topic3)
  end

  it 'finds results from the topic title or post content' do
    search_query = "made"
    Topic.full_text_search(search_query, @messageboard).should include(@topic1)
    Topic.full_text_search(search_query, @messageboard).should include(@topic2)
    Topic.full_text_search(search_query, @messageboard).should_not include(@topic3)
  end

  it 'finds results from the topic title or post content' do
    search_query = "made"
    Topic.full_text_search(search_query, @messageboard).should include(@topic1)
    Topic.full_text_search(search_query, @messageboard).should include(@topic2)
    Topic.full_text_search(search_query, @messageboard).should_not include(@topic3)
  end
end
