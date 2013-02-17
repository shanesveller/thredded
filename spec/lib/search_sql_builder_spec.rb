require 'spec_helper'

describe SearchSqlBuilder, 'build' do
  it 'finds results for a simple text search' do
    messageboard = create(:messageboard)
    topic = create(:topic, messageboard: messageboard)
    topic.posts.create!(topic: topic, messageboard: topic.messageboard, content: 'alpine spring is very refreshing')

    search_query = ' spring '
    Topic.full_text_search(search_query, messageboard).should_not be_empty

    search_query = '"alpine spring"'
    Topic.full_text_search(search_query, messageboard).should_not be_empty
  end

  it 'finds only 1 result with similar posts in different categories' do
    messageboard = create(:messageboard)
    topic1 = create(:topic, messageboard: messageboard, title: 'A funny category topic', with_categories: 1)
    topic2 = create(:topic, messageboard: messageboard, title: 'A beer category topic', with_categories: 1)

    topic1.posts.create!(topic: topic1, messageboard: topic1.messageboard, content: 'spring board cats')
    topic2.posts.create!(topic: topic2, messageboard: topic2.messageboard, content: 'alpine spring is very refreshing')

    search_query = "spring in:#{topic1.categories[0].name}"
    Topic.full_text_search(search_query, messageboard).should have(1).item
  end

  it 'finds only 1 result with similar posts by different users' do
    messageboard = create(:messageboard)
    joel = create(:user, name: 'joel')
    shaun = create(:user, name: 'shaun')

    topic1 = create(:topic, messageboard: messageboard, title: 'Joel made a topic', user: joel)
    topic2 = create(:topic, messageboard: messageboard, title: 'Shaun made a topic', user: shaun)

    topic1.posts.create!(topic: topic1, messageboard: topic1.messageboard, content: 'spring board cats')
    topic2.posts.create!(topic: topic2, messageboard: topic2.messageboard, content: 'alpine spring is very refreshing')

    search_query = 'spring by:shaun'
    Topic.full_text_search(search_query, messageboard).should have(1).item
  end
end
