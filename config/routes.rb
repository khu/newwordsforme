Keepin::Application.routes.draw do
  match "/login",  :to => "user_sessions#new"
  match "/logout", :to => "user_sessions#destroy"
  match "/signup", :to => "users#new"
  match '/addons',  :to => 'pages#addons'
  match '/mobile',  :to => 'pages#mobile'
  match '/plugins', :to => 'pages#plugins'
  match '/contact', :to => 'pages#contact'
  match '/about',   :to => 'pages#about'
  match '/help',    :to => 'pages#help'
  match '/get_word_tags', :to => 'words#get_word_tags'
  
  match 'users/:id/words/:word', :to => 'words#show_word', :as => "show_word"
  
  # as---- you can use this path by alias
  # the first 'users/:id/tag/:name'-----indicate the parameters and the url path
  # to----- indicate the controller and the action, in the action ,you can use params to fetch the parameter in the first path
  match 'users/:id/tag/:name', :to => 'users#show_word_by_tag', :as => "show_tag_word"

  root :to => 'pages#home'
  
  get "users/new"

  get "sessions/new"

  resources :users do
    resources :words
  end
  
  resources :user_sessions
  
  post "words/add_tag"  
  
  post "words/delete_tag"
  
  post "sessions/userid"

  post "words/update_tag"
  
  post "words/update_words"

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
