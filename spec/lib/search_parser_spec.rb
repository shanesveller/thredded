require 'spec_helper'

describe SearchParser, 'parse' do
  it 'parses a plain text query' do
    search = 'Alpine Spring'
    arg_list = SearchParser.new(search).parse
    arg_list['text'].should include('Alpine')
    arg_list['text'].should include('Spring')
  end

  it 'parses a query containing quotes' do
    search = '"Alpine Spring"'
    arg_list = SearchParser.new(search).parse
    arg_list['text'].should include('"Alpine Spring"')
    arg_list['text'].should have(1).item
  end

  it 'parses a query with an in: and by:' do
    search = 'by: shaun in:NWS'
    arg_list = SearchParser.new(search).parse
    arg_list['by'].should include('shaun')
    arg_list['in'].should include('NWS')
  end

  it 'parses a query containing quotes and by a user' do
    search = '"Alpine Spring" by:shaun'
    arg_list = SearchParser.new(search).parse
    arg_list['text'].should include('"Alpine Spring"')
    arg_list['by'].should include('shaun')
  end

  it 'parses a query containing quotes, by a user and in a category' do
    search = 'in:Beer "Alpine Spring" by:shaun'
    arg_list = SearchParser.new(search).parse
    arg_list['text'].should include('"Alpine Spring"')
    arg_list['by'].should include('shaun')
    arg_list['by'].should_not include('Beer')
    arg_list['in'].should include('Beer')
    arg_list['in'].should_not include('shaun')
  end

  it 'does not contain duplicate items' do
    search = 'in: beer by:shaun allagash'
    arg_list = SearchParser.new(search).parse
    arg_list['in'].length.should == 1
    arg_list['by'].length.should == 1
  end

  it 'parses a query containing quotes, by a user, in a category' do
    search = 'in:Beer "Alpine Spring" by:shaun'
    arg_list = SearchParser.new(search).parse
    arg_list['text'].should include('"Alpine Spring"')
    arg_list['by'].should include('shaun')
    arg_list['in'].should include('Beer')
  end

  it 'parses a query containing quotes, by a user and in category X or category Y' do
    search = 'in:Beer "Alpine Spring" by:shaun in:Sports'
    arg_list = SearchParser.new(search).parse
    arg_list['text'].should include('"Alpine Spring"')
    arg_list['by'].should include('shaun')
    arg_list['in'].should include('Beer')
    arg_list['in'].should include('Sports')
  end
end
