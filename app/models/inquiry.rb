class Inquiry < ApplicationRecord
  validates :name, presence: true
  validates :mail, presence: true
  validates :inquiry_comment, presence: true
end
