Rails.application.routes.draw do
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
  end

  resources :categories, only: [:index, :show] do
    collection do
      get 'featured'
      get 'on_sale'
    end
    member do
      get 'related'
    end
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