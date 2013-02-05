Tradein::Application.routes.draw do

  if Rails.env.cucumber?
    map.login_backdoor '/login/:email',
      :controller => 'sessions', :action => 'backdoor'
  end

  resources :blocks

  resources :subscribtions

  devise_for :user
  resources :countries
  resources :schedules do
    put 'confirm'
    resources :blocks
  end

  resources :links

  match ':id.pdf' => 'reports#show',:constraints => { :id => /\d.+/ }, :format => 'pdf'
  match ':id' => 'reports#show',:constraints => { :id => /\d.+/ }

  resources :feedbacks
  resources :companies do
    put 'upload_logotype'
  end

  put 'profiles/update_password'

  resources :profiles
  resources :points do
    resources :image
    resources :assets
  end

  get 'assets/processed'
  get "home/index"
  get 'home/demo'

  match 'view/22', :controller => :home, :action => :demo


  resources :user, :except => [:index, :edit, :new, :show, :create, :update, :destroy] do
    resource :profile
  end

  resources :models do
    get 'index_block'
  end

  resources :reports do
    get 'empty_form'
    resources :links
    resources :points
    resources :defects
    resources :assets
    post 'place'
    delete 'remove_asset'
    get 'image'
    get 'images'
    get 'all_images'
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

