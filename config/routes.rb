Rails.application.routes.draw do
  root to: "top#index"
  get 'rooms/search' => 'rooms#search' 
  get 'rooms/area_search' => 'rooms#area_search' 
  resources :rooms
  resources :reservations
  resources :top

  
  devise_for :users, controllers: {registrations: 'users/registrations', sessions: 'users/sessions'}

  devise_scope :user do
    get "users/account", :to => "users/registrations#account"
    get "users/profile", :to => "users/registrations#profile"
    get "users", :to => "users/registrations#account"
    get "signup", :to => "users/registrations#new"
    get "logout", :to => "users/sessions#destroy"
  end

  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
