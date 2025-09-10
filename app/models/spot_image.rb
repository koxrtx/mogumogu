class SpotImage < ApplicationRecord
  belongs_to :spot
  has_many :spot_update_request_images, dependent: :destroy

  validates :spot_id, presence: true
end
