class User < ApplicationRecord
  has_many :realdiaries
  has_many :futurediaries
end
