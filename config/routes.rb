Rails.application.routes.draw do
  require "sidekiq/web"
  mount Sidekiq::Web => "/sidekiq"
  devise_for :users, only: :omniauth_callbacks, controllers: {omniauth_callbacks: 'users/omniauth_callbacks'}
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"

    get "admin/dashboard", to: "admin#dashboard"
    get "/search", to: "static_pages#search"

    devise_for :users, controllers: { registrations: "users/registrations" }, skip: :omniauth_callbacks

    resources :users, only: [:show, :edit, :update] do
      resources :orders, only: [:index, :destroy]
    end
    resources :products, only: [:index, :show]
    resources :categories, only: [:show]
    resources :tables, only: :index
    resources :orders, only: [:new, :create]
    resources :notifications, only: [:update, :index]

    namespace :admin do
      resources :reports, only: [:index] do
        collection do
          post :report
          get :report, to: "reports#index"
        end
      end
      resources :tables do
        collection do
          get :sort, to: "tables#sort"
        end
      end
      resources :orders do
        resources :order_details do
          member do
            get :update_amount, to: "order_details#update_amount"
          end
        end
        collection do
          get :search
          get :sort, to: "orders#sort"
        end
        member do
          get :order_status, to: "orders#order_status_change"
          post :order_update_table, to: "orders#order_update_table"
          post :paid, to: "orders#paid"
        end
      end
      resources :products do
        collection do
          get :sort, to: "products#sort"
          get :search, to: "products#search"
        end
      end
      resources :categories do
        collection do
          get :search, to: "categories#search"
          get :sort, to: "categories#sort"
        end
      end
      resources :users do
        collection do
          get :search, to: "users#search"
          get :sort, to: "users#sort"
        end
      end
    end
  end
end
