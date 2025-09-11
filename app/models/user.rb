class User < ApplicationRecord
  # ユーザーが削除されても店舗情報や修正依頼は消えない
  has_many :spots, dependent: :nullify
  has_many :spot_update_requests, dependent: :nullify

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :encrypted_password, presence: true

  # enumの定義（roleが0: user, 1: adminの場合）
  enum :role { user: 0, admin: 1 }
end
