class User < ApplicationRecord
  # Devise モジュールを追加
  # :database_authenticatable → パスワード暗号化
  # :registerable → サインアップ機能
  # :recoverable → パスワードリセット
  # :rememberable → ログイン保持
  # :validatable → メールとパスワードのバリデーション
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:line, :google_oauth2]
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

  def self.from_omniauth(auth, current_user = nil)
    # ログイン済みユーザーがLINE・Google連携を追加する場合
    return external_authentication_account(auth, current_user) if current_user && !current_user.provider_connected?(auth.provider)

    # 既存のLINE・Googleユーザーでログインまたは新規ユーザー作成
    sign_in_or_create_user(auth)
  end

  # 既存ユーザーにLINE/Google連携を追加
  def self.external_authentication_account(auth, current_user)
    # 他のユーザーが既にこのLINE・Googleアカウントを使用していないかチェック
    return nil if exists?(provider: auth.provider, uid: auth.uid)

    success = current_user.update(
      provider: auth.provider,
      uid: auth.uid
    )

    success ? current_user : nil
  end

  # LINE/Googleログインまたは新規ユーザー作成
  def self.sign_in_or_create_user(auth)
    find_or_create_by(
      provider: auth.provider,
      uid: auth.uid
    ) do |user|
      user.email = auth.info.email || "#{auth.uid}@line.example.com"
      user.name = auth.info.name || "User"
      user.password = Devise.friendly_token[0, 20]
    end
  end

  # LINE/Google連携チェックメソッド
  def provider_connected?(provider_name)
    case provider_name.to_s
    when 'line'
      line_connected?
    when 'google_oauth2'
      google_connected?
    else
      false
    end
  end

  # OAuth認証ユーザー（LINEまたはGoogle）
  def oauth_user?
    (line_user? || google_user?) && uid.present?
  end

  # LINEユーザーか
  def line_user?
    provider == 'line'
  end

  # Googleユーザーか
  def google_user?
    provider == 'google_oauth2'
  end

  # LINE通知が有効か
  def line_notify_enabled?
    line_connected?
  end
end