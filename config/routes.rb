Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  # ホーム画面
  root "home#index"
end
