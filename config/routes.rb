Tradein::Application.routes.draw do

  resources :companies

  resources :profiles
  resources :assets

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

