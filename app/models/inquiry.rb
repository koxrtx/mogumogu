class Inquiry < ApplicationRecord
  # 独立したテーブル設計のため関連付けなし
  # 必須項目
  validates :name, presence: true
  validates :email, presence: true
  validates :inquiry_comment, presence: true

  # 保留・対応中・完了のステータス
  enum :status, { pending: 0, in_progress: 1, completed: 2 }
end
