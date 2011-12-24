Thredded::Application.routes.draw do


  # The priority is based upon order of creation:
  # first created -> highest priority.

  devise_for :users 
  resources :users
  
  constraints(PersonalizedDomain.new) do
    root :to => "messageboards#index"
    match "/:messageboard_id(.:format)"                         => 'messageboards#show', :as => :messageboard
    match "/:messageboard_id/topics(.:format)"                  => 'topics#create',      :as => :create_messageboard_topic
    match "/:messageboard_id/topics/new/(:type)"                => 'topics#new',         :as => :new_messageboard_topic
    match "/:messageboard_id/:topic_id/edit(.:format)"          => 'topics#edit',        :as => :edit_messageboard_topic
    match "/:messageboard_id/:topic_id(.:format)"               => 'topics#update',     :via => :put
    match "/:messageboard_id/:topic_id(.:format)"               => 'topics#show',        :as => :messageboard_topic
    match "/:messageboard_id/:topic_id/posts(.:format)"         => 'posts#create',       :as => :create_messageboard_topic_post
    match "/:messageboard_id/:topic_id/:post_id(.:format)"      => 'posts#update',      :via => :put
    match "/:messageboard_id/:topic_id/:post_id(.:format)"      => 'posts#show',         :as => :messageboard_topic_post
    match "/:messageboard_id/:topic_id/:post_id/edit(.:format)" => 'posts#edit',         :as => :edit_messageboard_topic_post
    resources :messageboards do
      resources :topics do
        resources :posts
      end
    end
  end

  root :to => "home#index"

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

end
