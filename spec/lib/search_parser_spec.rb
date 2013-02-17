require 'spec_helper'

describe SearchParser, 'parse' do
  it 'parses a plain text query' do
    search = 'Alpine Spring'
    arg_list = SearchParser.new(search).parse
    arg_list.should include('Alpine')
    arg_list.should include('Spring')
  end

  it 'parses a query containing quotes' do
    search = '"Alpine Spring"'
    arg_list = SearchParser.new(search).parse
    arg_list.should include('"Alpine Spring"')
    arg_list.should have(1).item
  end

  it 'parses a query with an in: and by:' do
    search = 'by: shaun in:NWS'
    arg_list = SearchParser.new(search).parse
    arg_list.should include('by:shaun')
    arg_list.should include('in:NWS')
  end

  it 'parses a query containing quotes and by a user' do
    search = '"Alpine Spring" by:shaun'
    arg_list = SearchParser.new(search).parse
    arg_list.should include('"Alpine Spring"')
    arg_list.should include('by:shaun')
  end

  it 'parses a query containing quotes, by a user and in a category' do
    search = 'in:Beer "Alpine Spring" by:shaun'
    arg_list = SearchParser.new(search).parse
    arg_list.should include('"Alpine Spring"')
    arg_list.should include('by:shaun')
    arg_list.should include('in:Beer')
  end

  it 'parses a query containing quotes, by a user, in a category' do
    search = 'in:Beer "Alpine Spring" by:shaun'
    arg_list = SearchParser.new(search).parse
    arg_list.should include('"Alpine Spring"')
    arg_list.should include('by:shaun')
    arg_list.should include('in:Beer')
  end

  it 'parses a query containing quotes, by a user and in category X or category Y' do
    search = 'in:Beer "Alpine Spring" by:shaun in:Sports'
    arg_list = SearchParser.new(search).parse
    arg_list.should include('"Alpine Spring"')
    arg_list.should include('by:shaun')
    arg_list.should include('in:Beer')
    arg_list.should include('in:Sports')
  end
end
