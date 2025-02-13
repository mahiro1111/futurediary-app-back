class OauthController < ApplicationController
	require "google-id-token"

	def google_oauth
		token = params[:token]
		#google-id-tokenのライブラリ機能(id-tokenを検証) #インスタンスを生成
		validator = GoogleIDToken::Validator.new

		begin
			#GoogleのクライアントIDでトークンを検証
			payload = validator.check(token, "MY_GOOGLE_CLIENT_ID")

			#ユーザー情報をDBに保存/更新
			user = User.find_or_create_by(email: payload['email']) do |u|
				u.username = payload['name']
				u.password = SecureRandom.hex(10) #passwordをランダム生成
			end

			#JWTトークンを発行（ログイン状態にするため）
			#フロントでdecodeしてもらってuser_idを取得
			jwt_token = JWT.encode({ user_id: user.id }, Rails.application.secrets.secret_key_base)
			render json:{ user: user, token: jwt_token }, status: :ok

		rescue StandardError => e
			render json:{ error: e.message }, status: :unauthorized
		end
	end
end
