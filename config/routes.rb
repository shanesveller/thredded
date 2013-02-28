Thredded::Application.routes.draw do
  ActiveAdmin.routes(self)

  mount_sextant if Rails.env.development?
  devise_for :users, controllers: { registrations: 'registrations', sessions: 'sessions' }
  resources :users

  devise_scope :user do
    match '/auth/:provider/callback', to: 'sessions#create'
  end

  get '/auth/failure', to: redirect('/')
  get '/auth/github', as: :auth_github
  put '/identities' => 'identities#update', as: :identity
  post '/mail/receive' => 'griddler/emails#create'

  constraints(SetupThredded.new) do
    root to: 'setups#new'
    get '/:step' => 'setups#new', constraints: { step: /\d{1}/ }, as: :new_setup
    post '/:step' => 'setups#create', constraints: { step: /\d{1}/ }, as: :create_setup
    resource :setup
  end

  constraints(PersonalizedDomain.new) do
    root to: 'messageboards#index'

    resources :preferences

    constraints(lambda{|req| req.env["QUERY_STRING"].include? 'q=' }) do
      match "/:messageboard_id(.:format)" => 'topics#search', as: :messageboard_search, via: :get
    end

    match '/login' => redirect('/users/sign_in')
    match '/log_in' => redirect('/users/sign_in')
    match '/sign_in' => redirect('/users/sign_in')
    match '/logout' => redirect('/users/sign_out')
    match '/log_out' => redirect('/users/sign_out')
    match '/forgot_password' => redirect('/users/password/new')
    match '/user/forgot_password' => redirect('/users/password/new')
    match '/user/forgot_username' => redirect('/users/password/new')

    match '/:messageboard_id(.:format)' => 'topics#index', as: :messageboard_topics
    match '/:messageboard_id/topics(.:format)' => 'topics#create', as: :create_messageboard_topic
    match '/:messageboard_id/topics/new/(:type)' => 'topics#new', as: :new_messageboard_topic
    match '/:messageboard_id/private_topics(.:format)' => 'private_topics#create', as: :create_messageboard_private_topic
    match '/:messageboard_id/private_topics/new/(:type)' => 'private_topics#new', as: :new_messageboard_private_topic
    match '/:messageboard_id/topics/category/:category_id' => 'topics#by_category', as: :messageboard_topics_by_category
    match '/:messageboard_id/:topic_id/edit(.:format)' => 'topics#edit', as: :edit_messageboard_topic
    match '/:messageboard_id/:topic_id(.:format)' => 'topics#update', as: :messageboard_topic, via: :put
    match '/:messageboard_id/:topic_id(.:format)' => 'posts#index', as: :messageboard_topic_posts
    match '/:messageboard_id/:topic_id/posts(.:format)' => 'posts#index', via: :get
    match '/:messageboard_id/:topic_id/posts(.:format)' => 'posts#create', as: :create_messageboard_topic_post, via: :post
    match '/:messageboard_id/:topic_id/:post_id(.:format)' => 'posts#update', via: :put
    match '/:messageboard_id/:topic_id/:post_id(.:format)' => 'posts#show', as:  :messageboard_topic_post
    match '/:messageboard_id/:topic_id/:post_id/edit(.:format)' => 'posts#edit', as:  :edit_messageboard_topic_post

    resources :messageboards do
      resources :topics do
        resources :posts
      end
    end
  end

  root to: 'home#index'
end
