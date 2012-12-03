Tradein::Application.routes.draw do
  
  resources :links

  match ':id.pdf' => 'reports#show',:constraints => { :id => /\d.+/ }, :format => 'pdf'
  match ':id' => 'reports#show',:constraints => { :id => /\d.+/ }
  resources :feedbacks

  resources :companies

  put 'profiles/update_password'
  resources :profiles
  
  get 'assets/processed'
  # resources :assets

  resources :points do
    resources :image
    resources :assets
  end

  get "home/index"
  get 'home/demo'
  
  match 'view/22', :controller => :home, :action => :demo
  
  devise_for :user

  resources :user, :except => [:index, :edit, :new, :show, :create, :update, :destroy] do
    resource :profile
  end


  resources :models do
    get 'index_block'
  end

 

  resources :reports do
    resources :links
    resources :points
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
  
  root :to => 'home#partners', :constraints => {:subdomain => "partners"}
  root :to => 'home#partners', :constraints => {:subdomain => "partner"}
  root :to => 'home#index'

  match 'new_file', :controller => 'ftp', :action => 'file'
  match 'google5bf74eb79251ba45.html',  :controller => 'static', :action => 'google_validation'
end

