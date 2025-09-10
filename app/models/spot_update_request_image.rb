class SpotUpdateRequestImage < ApplicationRecord
  belongs_to :spot_update_request
  belongs_to :spot_image

  # 同じリクエストで同じ画像を2回登録できないようにする
  validates :spot_image_id, uniqueness: { scope: :spot_update_request_id }
end
