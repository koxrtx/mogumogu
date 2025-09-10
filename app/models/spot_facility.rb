class SpotFacility < ApplicationRecord
  # 中間テーブル
  belongs_to :spot
  belongs_to :facility_tag

  # spot_id と facility_tag_id の組み合わせがユニークであることを保証
  validates :facility_tag_id, uniqueness: { scope: :spot_id }
end
