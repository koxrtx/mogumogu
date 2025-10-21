Rails.application.routes.draw do

  # Devise用ルーティング
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  # ホーム画面
  root "home#index"

  # 利用規約画面
  get "/terms", to: "pages#terms"
  # 利用規約同意画面
  get "/terms_agreement", to: "pages#terms_agreement"
  post "/terms_agreement", to: "agreements#create"

  # 現在地から検索
  get "maps/search", to: "maps#search", as: :search_map

  # お店の情報投稿
  resources :spots, only: [:new, :create, :show]
end
