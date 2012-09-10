Tradein::Application.routes.draw do

  resources :points do
    resources :image
  end

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
  root :to => 'home#index'

  match 'new_file', :controller => 'ftp', :action => 'file'
  match 'google5bf74eb79251ba45.html',  :controller => 'static', :action => 'google_validation'
end

