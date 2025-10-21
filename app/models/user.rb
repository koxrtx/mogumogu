class User < ApplicationRecord
  # Devise モジュールを追加
  # :database_authenticatable → パスワード暗号化
  # :registerable → サインアップ機能
  # :recoverable → パスワードリセット
  # :rememberable → ログイン保持
  # :validatable → メールとパスワードのバリデーション
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:line]
  # ユーザーが削除されても店舗情報や修正依頼は消えない
  has_many :spots, dependent: :nullify
  has_many :spot_update_requests, dependent: :nullify
  has_many :agreements

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, unless: :oauth_user?
  # Devise が自動でバリデーションするので不要
  # validates :encrypted_password, presence: true
  # OAuth認証の重複防止
  validates :uid, uniqueness: { scope: :provider }, if: -> { provider.present? }

  # enumの定義（roleが0: user, 1: adminの場合）
  enum :role, { user: 0, admin: 1 }

  # OmniAuthからユーザーを作成取得する
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.name = auth.info.name
      user.provider = auth.provider
      user.uid = auth.uid

      # パスワードを自動生成
      user.password = Devise.friendly_token[0, 20]
    end
  end

  # OAuth認証ユーザーか
  def oauth_user?
    provider.present? && uid.present?
  end

  # LINEユーザーか
  def line_user?
    provider == 'line'
  end
end
