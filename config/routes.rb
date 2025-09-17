Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  # Devise用ルーティング
  devise_for :users

  # ホーム画面
  root "home#index"
  # 利用規約画面
  get "/terms", to: "pages#terms"
end
