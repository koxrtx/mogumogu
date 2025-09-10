# app/models/spot_update_request_image.rb
class SpotUpdateRequestImage < ApplicationRecord
  belongs_to :spot_update_request
  belongs_to :spot_image

  validates :spot_update_request_id, presence: true
  validates :spot_image_id, presence: true

  validates :spot_image_id, uniqueness: { scope: :spot_update_request_id }
end
