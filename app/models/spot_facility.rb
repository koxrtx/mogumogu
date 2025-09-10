class SpotFacility < ApplicationRecord
  # 多対対
  belongs_to :spot
  belongs_to :facility_tag

  validates :spot_id, presence: true
  validates :facility_tag_id, presence: true

  # spot_id と facility_tag_id の組み合わせがユニークであることを保証
  validates :facility_tag_id, uniqueness: { scope: :spot_id }
end
