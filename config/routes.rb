Rails.application.routes.draw do
  # get "spots/index"
  # get "spots/show"
  # get "spots/create"
  # get "spots/edit"
  # get "spots/update"
  # get "spots/destroy"
  # get "up" => "rails/health#show", as: :rails_health_check

  resources :spots, only: [:new, :create, :show]

  # Devise用ルーティング
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  # ホーム画面
  root "home#index"
  # 利用規約画面
  get "/terms", to: "pages#terms"
  # 利用規約同意画面
  get "/terms_agreement", to: "pages#terms_agreement"
  post "/terms_agreement", to: "agreements#create"
end
