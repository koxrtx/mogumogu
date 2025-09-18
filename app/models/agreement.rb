class Agreement < ApplicationRecord
  belongs_to :user

  validates :terms_version, presence: true
  validates :agreed_at, presence: true
  validates :ip_address, presence: true
end
