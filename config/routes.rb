SampleApp::Application.routes.draw do
  
  resources :users
  resources :sessions, :only => [:new, :create, :destroy]
  resources :polls
  resources :items

  #get "pages/home"

  #get "pages/contact"

  #get "pages/about"
  #match '/contact',:to => 'pages#contact'
  match '/about', :to => 'pages#about'
  match '/help', :to=>'pages#help'
  #match '/audiences/:poll_id', :to => "audiences#create"
  match '/voted_choice', :to => "polls#store_choice"
  match '/signup', :to => 'users#new'
  match '/signin', :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'
  #match '/sessions', :to => 'sessions#create' implicitly created by resources
  match '/', :to=>'pages#home'
  root :to => 'pages#home'
  match 'contact' => 'contacts#new', :as => 'contacts', :via => :get
  match 'contact' => 'contacts#create', :as => 'contacts', :via => :post
  match '/legal/terms' => 'pages#terms'
  match '/auth/facebook/callback' => "sessions#create_fb"
  match '/item/delete' => 'items#destroy'
  match '/publish/polls/:id' => 'polls#publish'
  match '/polls/:id/create_item' => 'items#create'
  match '/auth/failure' => 'sessions#fb_signin_failure'
  match '/consumers' => 'pages#consumer'
  match '/retailers' => 'pages#retailer'
  match '/users/pre_sign_up' => 'users#pre_sign_up'
  match '/retailers/pre_sign_up' => 'retailers#pre_sign_up'
  
  #for testing the auto email sent to the user after the pre-launch signup
  match '/test_email' => 'users#test_email'
  #match '/update/polls/:id' => 'polls#update'

  match '/admin/polls/:page' => 'polls#index'
  match '/admin/polls_to_json/:page' => 'polls#polls_to_json'
  match '/admin/items/:id/edit' => 'items#edit'
  match '/items/:item_id/delete' => 'items#destroy'
  put '/items/:id' => 'items#update'

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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
