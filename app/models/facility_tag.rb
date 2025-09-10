class FacilityTag < ApplicationRecord
  has_many :spot_facilities, dependent: :destroy
  has_many :spots, through: :spot_facilities

  validates :content, presence: true
end
