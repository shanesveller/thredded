Thredded::Application.routes.draw do

  # first created -> highest priority.

  constraints(SetupThredded.new) do
    root :to => "setups#new"
    match "/:step" => 'setups#new',    :constraints => { :step => /\d{1}/ }, :as => :new_setup, :via => :get
    match "/:step" => 'setups#create', :constraints => { :step => /\d{1}/ }, :as => :create_setup, :via => :post
    resource :setup
  end

  devise_for :users 
  resources :users

  namespace :admin do
    resources :sites do
      resources :messageboards
      resources :users
    end
  end
  
  constraints(PersonalizedDomain.new) do
    root :to => "admin/messageboards#index"
    match "/:messageboard_id(.:format)"                         => 'topics#index',       :as => :messageboard_topics
    match "/:messageboard_id/topics(.:format)"                  => 'topics#create',      :as => :create_messageboard_topic
    match "/:messageboard_id/topics/new/(:type)"                => 'topics#new',         :as => :new_messageboard_topic
    match "/:messageboard_id/:topic_id/edit(.:format)"          => 'topics#edit',        :as => :edit_messageboard_topic
    match "/:messageboard_id/:topic_id(.:format)"               => 'topics#update',      :as => :messageboard_topic, :via => :put
    match "/:messageboard_id/:topic_id(.:format)"               => 'posts#index',        :as => :messageboard_topic_posts
    match "/:messageboard_id/:topic_id/posts(.:format)"         => 'posts#create',       :as => :create_messageboard_topic_post
    match "/:messageboard_id/:topic_id/:post_id(.:format)"      => 'posts#update',       :via => :put
    match "/:messageboard_id/:topic_id/:post_id(.:format)"      => 'posts#show',         :as => :messageboard_topic_post
    match "/:messageboard_id/:topic_id/:post_id/edit(.:format)" => 'posts#edit',         :as => :edit_messageboard_topic_post
    resources :messageboards do
      resources :topics do
        resources :posts
      end
    end
  end

  root :to => "home#index"

end
