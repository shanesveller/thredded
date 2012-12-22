require 'spec_helper'

describe AtNotificationExtractor, 'extract' do
  it 'extracts username from post content' do
    post = build_stubbed(:post, content: 'hey @joel how are you. @steve')

    AtNotificationExtractor.new(post.content).extract.should eq(['joel', 'steve'])
  end

  it 'consolidates multiples of usernames into single name' do
    post = build_stubbed(:post, content: '@joel @joel @joel. @steve @steve')

    AtNotificationExtractor.new(post.content).extract.should eq(['joel', 'steve'])
  end

  it 'extracts names wrapped in quotes' do
    post = build_stubbed(:post, content: '@joel @"john doe" @joel')

    AtNotificationExtractor.new(post.content).extract.should eq(['joel', 'john doe'])
  end
end
