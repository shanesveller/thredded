require 'spec_helper'

describe TopicsController do
  before do
    @user = create(:user)
    @site = create(:site)
    @messageboard = create(:messageboard, site: @site)
    @topic = create(:topic, messageboard: @messageboard, title: 'hi')
    @post = create(:post, topic: @topic, content: 'hi')
    controller.stubs(:get_topics).returns([@topic])
    controller.stubs(:get_sticky_topics).returns([])
    controller.stubs(:cannot?).returns(false)
    controller.stubs(:current_user).returns(@user)
    controller.stubs(:site).returns(@site)
    controller.stubs(:messageboard).returns(@messageboard)
  end

  describe "GET 'index'" do
    it 'renders index' do
      controller.stubs(:get_search_results).returns([@topic])
      get :index, messageboard_id: @messageboard.id
      response.should be_success
      response.should render_template('index')
    end
  end

  describe "GET 'search'" do
    it 'renders search' do
      get :search, messageboard_id: @messageboard.id, q: 'hi'
      response.should be_success
      response.should render_template('search')
    end

    it 'is successful with spaces around search term(s)' do
      get :search, messageboard_id: @messageboard.id, q: '  hi  '
      response.should be_success
    end
  end
end
