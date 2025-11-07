class Inquiry < ApplicationRecord
  # 独立したテーブル設計のため関連付けなし
  # 必須項目
  validates :name, presence: true
  validates :email, presence: true
  validates :inquiry_comment, presence: true
  # 文字数制限
  validates :name, length: { maximum: 50, message: "名前は50文字以内で入力してください" }
  validates :inquiry_comment, length: { maximum: 1000, message: "お問い合わせ内容は1000文字以内で入力してください"  }

  # email_validator(メールアドレス形式チェック)
  validates :email, email: {
    message: "正しいメールアドレスの形式で入力してください（例：example@email.com）"
  }

  # 保留・対応中・完了のステータス
  enum :status, { pending: 0, in_progress: 1, completed: 2 }
end
