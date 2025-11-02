Rails.application.routes.draw do

  # Devise用ルーティング
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  # ホーム画面
  root "home#index"
  # オートコンプリート用
  get '/search', to: 'home#search'
  get 'spots', to: 'home#index'

  # マイページ
  get '/mypage', to: 'users#mypage', as: :mypage
  get '/mypage/edit', to: 'users#edit_mypage', as: :edit_mypage
  patch '/mypage', to: 'users#update_mypage', as: :update_mypage

  # 利用規約画面
  get "/terms", to: "pages#terms"
  # 利用規約同意画面
  get "/terms_agreement", to: "pages#terms_agreement"
  post "/terms_agreement", to: "agreements#create"

  # 現在地から検索
  get "maps/search", to: "maps#search", as: :search_map

  # お店の情報投稿
  resources :spots, only: [:new, :create, :show]

  # 管理者画面
  namespace :admin do
    root to: "dashboard#index"
    # ユーザー管理
    resources :users, only: [:index, :show, :destroy] do
      # 個別のリソースに対するルート
      member do
        patch :update_role
      end
    end
    resources :spots, only: [:index, :show, :destroy]
    resources :inquiries, only: [:index, :show, :destroy]
  end

  # 開発環境でメール確認
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
