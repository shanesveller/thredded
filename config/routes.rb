Thredded::Application.routes.draw do


  resources :sites do
    resources :users
    resources :messageboards do
      resources :topics do
        resources :posts
      end
    end
  end

  devise_for :users do
    get  "/:site_id/users/sign_in(.:format)"  => "devise/sessions#new",       :as => :new_user_session
    post "/:site_id/users/sign_in(.:format)"  => "devise/sessions#create",    :as => :user_session
    get  "/:site_id/users/sign_out(.:format)" => "devise/sessions#destroy",   :as => :destroy_user_session
    get  "/:site_id/users/edit(.:format)"     => "devise/registrations#edit", :as => :edit_user_registration
    get  "/:site_id/users/sign_up(.:format)"  => "devise/registrations#new",  :as => :new_user_registration
  end

  match "/:site_id(.:format)"                            => 'messageboards#index',     :as => :site_messageboards
  match "/:site_id/:messageboard_id(.:format)"           => 'topics#index',             :as => :site_messageboard_topics
  match "/:site_id/:messageboard_id/:topic_id(.:format)" => 'posts#index',              :as => :site_messageboard_topic_posts
  match "/:site_id/users(.:format)"                      => 'users#index',              :as => :site_users
  match "/:site_id/users/new(.:format)"                  => 'users#new',                :as => :new_site_user
  match "/:site_id/users/:id/edit(.:format)"             => 'users#index',              :as => :edit_site_user

  if "test" == Rails.env
    match "/:site_id/users/sign_in(.:format)"              => 'devise/sessions#create',   :as => :user_session
    match "/:site_id/users/sign_in(.:format)"              => 'devise/sessions#new',      :as => :new_user_session
    match "/:site_id/users/sign_out(.:format)"             => 'devise/sessions#destroy',  :as => :destroy_user_session
    match "/:site_id/users/sign_up(.:format)"              => 'devise/registrations#new', :as => :new_user_registration
    match "/:site_id/users/:id(.:format)"                  => 'users#show',               :as => :site_user
  else
    match "/users/sign_in(.:format)"              => 'devise/sessions#create',   :as => :user_session
    match "/users/sign_in(.:format)"              => 'devise/sessions#new',      :as => :new_user_session
    match "/users/sign_out(.:format)"             => 'devise/sessions#destroy',  :as => :destroy_user_session
    match "/users/sign_up(.:format)"              => 'devise/registrations#new', :as => :new_user_registration
    match "/users/:id(.:format)"                  => 'users#show',               :as => :site_user
  end

  root :to => "messageboards#index"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

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

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
