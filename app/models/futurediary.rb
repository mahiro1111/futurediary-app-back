class Futurediary < ApplicationRecord
  belongs_to :user
  validates :title, presence: true
  validates :diary, presence: true
  validates :date, presence: true
end
