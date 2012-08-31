Tradein::Application.routes.draw do

  get "home/index"

  devise_for :users

  resources :defects do
    get 'images'
    resources :assets
    post 'place'
  end

  resources :models do
    get 'index_block'
  end

  get "asset/create"
  get 'assets/processed'


  resources :reports do
    get 'images'
    get 'all_images'
    resources :assets
    post 'place'
    delete 'remove_asset'
    get 'image'
    resources :defects
    collection do
      get 'models'
    end
    get 'counters'

  end

  get 'ftp/update_eye_fi'
  root :to => 'home#index'



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
  #   resources :products do Чтобы знать.
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
  # match ':controller(/:action(/:id(.:format)))'
  match 'index.php/rest', :controller => 'galleries', :action => 'rest'
  match 'index.php/rest/item(/:id)', :controller => 'galleries', :action => 'test'
  match 'new_file', :controller => 'ftp', :action => 'file'
  match 'google5bf74eb79251ba45.html',  :controller => 'static', :action => 'google_validation'
end

