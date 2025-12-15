class Inquiry < ApplicationRecord
  # 独立したテーブル設計のため関連付けなし
  # 必須項目
  validates :name, presence: true, length: { maximum: 50, message: "名前は50文字以内で入力してください" }
  validates :email, presence: true
  validates :inquiry_comment, presence: true, length: { maximum: 1000, message: "お問い合わせ内容は1000文字以内で入力してください"  }

  # email_validator(メールアドレス形式チェック)
  validates :email, email: {
    message: "正しいメールアドレスの形式で入力してください（例：example@email.com）"
    require_tld: true
  }

  # 保留・対応中・完了のステータス
  enum :status, { pending: 0, in_progress: 1, completed: 2 }

  # 管理者画面用の検索機能(スコープ)
  # 作成日時が新しい順に並べる
  scope :recent, -> { order(created_at: :desc) }
  # 今日作られたものだけを取得
  scope :today, -> { where(created_at: Date.current.all_day) }
  # 1週間以内に作られたものを取得
  scope :this_week, -> { where(created_at: 1.week.ago..Time.current) }
  # 未読の問い合わせだけを取得
  scope :unread, -> { where(status: :pending) }
  
  # 新着件数取得
  def self.unread_count
    unread.count
  end
  
  # 今日の件数
  def self.today_count
    today.count
  end

  # Ransack（検索で使える属性）を許可
  def self.ransackable_attributes(auth_object = nil)
    %w[id name email inquiry_comment status created_at updated_at]
  end

  # Ransackで関連を使う場合（今回は不要かも）
  def self.ransackable_associations(auth_object = nil)
    []
  end
end
