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

  def self.from_omniauth(auth, current_user = nil)
    # ログイン済みユーザーがLINE連携を追加する場合
    return link_line_account(auth, current_user) if current_user && !current_user.line_connected?

    # 既存のLINEユーザーでログインまたは新規ユーザー作成
    sign_in_or_create_user_from_line(auth)
  end

  # 既存ユーザーにLINE連携を追加
  def self.link_line_account(auth, current_user)
    # 他のユーザーが既にこのLINEアカウントを使用していないかチェック
    return nil if exists?(provider: auth.provider, uid: auth.uid)

    success = current_user.update(
      provider: auth.provider,
      uid: auth.uid
    )

    success ? current_user : nil
  end

  # LINEログインまたは新規ユーザー作成
  def self.sign_in_or_create_user_from_line(auth)
    find_or_create_by(
      provider: auth.provider,
      uid: auth.uid
    ) do |user|
      user.email = auth.info.email || "#{auth.uid}@line.example.com"
      user.name = auth.info.name || "LINE User"
      user.password = Devise.friendly_token[0, 20]
    end
  end

  # LINE連携チェックメソッド
  def line_connected?
    uid.present? && provider == 'line'
  end

  # OAuth認証ユーザーか
  def oauth_user?
    provider.present? && uid.present?
  end

  # LINEユーザーか
  def line_user?
    provider == 'line'
  end

  # LINE通知が有効か
  def line_notify_enabled?
    line_connected?
  end
end