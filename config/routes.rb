Tradein::Application.routes.draw do

  match '/switch_user', :controller => 'switch_user', :action => 'set_current_user'

  resources :cities


  resources :reports


  if Rails.env.cucumber?
    map.login_backdoor '/login/:email',
      :controller => 'sessions', :action => 'backdoor'
  end


  resources :blocks

  resources :subscriptions do
    resources :reports
  end


  devise_for :user
  resources :countries
  resources :schedules do
    put 'confirm'
    resources :blocks
  end

  resources :links

  match ':id.pdf' => 'reports#show', :constraints => { :id => /\d.+/ }, :format => 'pdf'
  match ':id' => 'reports#show', :constraints => { :id => /\d.+/ }

  resources :feedbacks
  resources :centers do
    resource :schedules
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
  match 'how-it-works', controller: :home, action: :how_it_works
  match 'for-buyers', controller: :home, action: :for_buyers
  match 'for-sellers', controller: :home, action: :for_sellers


  match 'view/22', :controller => :home, :action => :demo


  resources :user, :except => [:index, :edit, :new, :show, :create, :update, :destroy] do
    resource :profile
  end

  resources :models do
    get 'index_block'
  end

  resources :reports do
    get 'access'
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
  match 'f83a1dd76bdae0c18f2afed973b38acd', controller: 'reports', action: :list, format: :xml
  match 'google5bf74eb79251ba45.html',  :controller => 'static', :action => 'google_validation'
  # match 'yandex_4ed32e0d73358fa4.html', :controller => 'static', :action => 'yandex_validation'

end

