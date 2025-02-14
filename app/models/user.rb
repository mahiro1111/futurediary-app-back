class User < ApplicationRecord
  has_secure_password # bcryptを有効化

  has_many :realdiaries
  has_many :futurediaries

  validates :email, presence: true, uniqueness: true
end
