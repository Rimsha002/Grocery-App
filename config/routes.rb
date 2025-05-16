Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Authentication routes
  devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # Root path
  root 'home#index'

  # Products and categories
  resources :products, only: [:index, :show] do
    resources :reviews, except: [:index, :show]
    collection do
      get 'search'
    end
    get :search, on: :collection
  end

  # Cart
  resource :cart, only: [:show] do
    post 'add_item'
    delete 'remove_item'
    patch 'update_quantity'
    delete 'clear'
  end

  # Orders
  resources :orders, only: [:index, :show, :create] do
    member do
      patch 'cancel'
    end
  end

  # Wishlists
  resources :wishlists do
    member do
      post 'add_product'
      delete 'remove_product'
    end
  end

  # User account
  namespace :account do
    get 'dashboard', to: 'dashboard#index'
    get 'profile', to: 'profile#edit'
    patch 'profile', to: 'profile#update'
    resources :addresses
  end

  # Static pages
  get 'about', to: 'pages#about'
  get 'contact', to: 'pages#contact'
  get 'faq', to: 'pages#faq'
  get 'terms', to: 'pages#terms'
  get 'privacy', to: 'pages#privacy'
end
