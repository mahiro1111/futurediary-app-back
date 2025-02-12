class User < ApplicationRecord

  has_secure_password # bcryptを有効化

  has_many :realdiaries
  has_many :futurediaries

  validates :username, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, if: -> { password.present? }

end
