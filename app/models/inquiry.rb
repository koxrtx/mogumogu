class Inquiry < ApplicationRecord
  # 独立したテーブル設計のため関連付けなし
  validates :name, presence: true
  validates :mail, presence: true
  validates :inquiry_comment, presence: true
end
