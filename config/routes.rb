Rails.application.routes.draw do
  root to: 'top#index'
  get 'articles/score'
  resources :top, only: :index
  resources :maps, only: :show

  devise_for(
    # deviseのモデル
    :users,
    # deviseで生成するURLの基準となるパス
    path: 'settings',
    # deviseのコントローラがあるディレクトリ
    module: 'users'
  )

  # deviseにルーティングを追加する
  devise_scope :user do
    get '/login', to: 'users/sessions#new'
    get '/sign_up', to: 'users/registrations#new'
  end

  # deviseが更新不可だった場合のパス（/settings）が存在しないためリダイレクト
  get '/settings', to: redirect('/settings/edit')

  resources :user_profiles, path: 'settings', only: [] do
    get '/profile', to: 'user_profiles#edit', on: :member
    patch '/profile', to: 'user_profiles#update', on: :member
  end

  resources :rooms, only: %i(index show edit update destroy) do
    post '/create', to: 'rooms#create', on: :collection
    get '/create', to: 'rooms#new', on: :collection
  end

  resources :room_search_forms, only: :index do
    get 'area_search', on: :collection
  end

  resources :reservations do
    get 'registered', on: :member
    get 'completed', on: :collection
  end

  resources :reservation_hosts, path: 'hosts', only: %i(index show update) do
    get 'completed', on: :collection
  end

  resources :notifications, only: :index
  resources :rates, only: :create

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
