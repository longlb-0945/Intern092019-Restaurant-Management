Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
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
    resources :products
    resources :categories do
      collection do
        get :search, to: "categories#search"
        get :sort, to: "categories#sort"
      end
    end
  end
end
