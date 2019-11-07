Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"

    get "admin/dashboard", to: "admin#dashboard"
    devise_for :users, controllers: {registrations: "users/registrations"}
    resources :users, only: [:show, :edit, :update]
    resources :orders, only: [:new, :create]

    namespace :admin do
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
          delete ":id", to: "admin/users#destroy", as: :destroy_user
          get :search, to: "admin/users#search"
          get :sort, to: "admin/users#sort"
        end
      end
    end
  end
end
