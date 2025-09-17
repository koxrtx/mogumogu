class User < ApplicationRecord
  # Devise モジュールを追加
  # :database_authenticatable → パスワード暗号化
  # :registerable → サインアップ機能
  # :recoverable → パスワードリセット
  # :rememberable → ログイン保持
  # :validatable → メールとパスワードのバリデーション
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  # ユーザーが削除されても店舗情報や修正依頼は消えない
  has_many :spots, dependent: :nullify
  has_many :spot_update_requests, dependent: :nullify
  has_many :agreements

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  # Devise が自動でバリデーションするので不要
  # validates :encrypted_password, presence: true

  # enumの定義（roleが0: user, 1: adminの場合）
  enum :role, { user: 0, admin: 1 }
end
