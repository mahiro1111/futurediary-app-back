class User < ApplicationRecord
  has_secure_password # bcryptを有効化

  has_many :realdiaries
  has_many :futurediaries
  has_many  :schedules

  class User < ApplicationRecord
    # トークンを検証してユーザーを取得するメソッド
    def self.find_by_email_from_token(token)
      validator = GoogleIDToken::Validator.new
      payload = validator.check(token, 'YOUR_GOOGLE_CLIENT_ID')
      User.find_by(email: payload['email']) # ここでユーザーを取得
    end
  end

  validates :email, presence: true, uniqueness: true
end
