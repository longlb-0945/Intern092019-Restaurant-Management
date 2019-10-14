Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    resources :tables
    resources :orders do
      member do
        get :order_status, to: "orders#order_status_change"
      end
    end
    resources :order_tables
  end
end
