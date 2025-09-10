class Spot < ApplicationRecord
  belongs_to :user
  has_many :spot_facilities, dependent: :destroy
  has_many :facility_tags, through: :spot_facilities
  has_many :spot_images, dependent: :destroy
  has_many :spot_update_requests, dependent: :destroy
  has_many :inquiries, dependent: :nullify

  validates :name, presence: true
  validates :address, presence: true
end
