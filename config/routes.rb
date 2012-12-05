Shouter::Application.routes.draw do

  get "login", :to => 'sessions#new', :as => :login

  post "login", :to => 'sessions#create', :as => :login

  delete "logout", :to => 'sessions#destroy', :as => :logout
  get "logout", :to => 'sessions#destroy', :as => :logout

  # resources :sessions, :only => [:new, :create, :destroy]

  resources :users

  get '/signup', :to => 'users#new', :as => :signup

  resources :shouts

  post 'follow', to: 'follows#create', as: :follow
  delete 'unfollow', to: 'follows#destroy', as: :unfollow

  get 'tags/:name', to: 'tags#show', as: :tag

  root to: 'pages#home'

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  match ':controller(/:action(/:id))(.:format)'
end
