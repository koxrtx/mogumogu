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

  # マイページ 修正まとめる
  get '/mypage', to: 'users#mypage', as: :mypage
  get '/mypage/edit', to: 'users#edit_mypage', as: :edit_mypage
  patch '/mypage', to: 'users#update_mypage', as: :update_mypage

  # 利用規約画面
  get "/terms", to: "pages#terms"
  # 利用規約同意画面
  get "/terms_agreement", to: "pages#terms_agreement"
  post "/terms_agreement", to: "agreements#create"

  # 問い合わせ画面
  resources :inquiries, only: [:new, :create, :show]

  # プライバシーポリシー画面
  get "/privacy_policy", to: "pages#privacy_policy"

  # 現在地から検索
  get "maps/search", to: "maps#search", as: :search_map

  # お店の情報投稿
  resources :spots, only: [:new, :create, :show] do
    get 'update_requests/select_type', to: 'spot_update_requests#select_type'
    # 特定のspotに対する修正依頼
    resources :spot_update_requests, only: [:new, :create, :show]
  end

  # 管理者画面
  namespace :admin do
    root to: "dashboard#index"
    # ユーザー管理
    resources :users, only: [:index, :show, :destroy] do
      # 個別のリソースに対するルート(userの権限変更)
      member do
        patch :update_role
      end
    end
    resources :spots, only: [:index, :show, :destroy]
    resources :inquiries, only: [:index, :show, :destroy]do
    member do
      patch :mark_as_pending
      patch :mark_as_in_progress
      patch :mark_as_completed
    end
  end
    resources :spot_update_requests, only: [:index, :show, :edit, :update,:destroy] do
      member do
        patch :approve  # 承認アクション
        patch :reject   # 却下アクション
      end
    end

  end

  # 開発環境でメール確認
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
