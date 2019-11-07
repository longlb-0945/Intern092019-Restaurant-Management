Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"

    get "admin/dashboard", to: "admin#dashboard"

    namespace :admin do
      resources :tables
      resources :orders do
        resources :order_details do
          member do
            get :update_amount, to: "order_details#update_amount"
          end
        end
        member do
          get :order_status, to: "orders#order_status_change"
        end
      end
      resources :order_tables
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

    resources :password_resets, except: %i(show index destroy)

    get "/signup", to: "admin/users#new"
    get "/login", to: "sessions#new"

    post "/login", to: "sessions#create"

    delete "/logout", to: "sessions#destroy"
  end
end
