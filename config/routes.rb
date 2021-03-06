Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'callbacks' }

  authenticated do
    root to: "projects#index"
  end

  root to: "home#index"
  get "home/index"
  get "reports/index"

  resources :projects do
    patch :sort, on: :member

    resource :report do
      get 'download', to: 'reports#download'
    end
    resources :stories do
      get :real_scores, on: :collection, to: 'real_scores#edit'
      patch :real_scores, on: :collection, to: 'real_scores#update'
      patch :import, on: :collection
      get :export, on: :collection
      resources :estimates
    end
    resource :action_plan, only: [:show]
  end
end
