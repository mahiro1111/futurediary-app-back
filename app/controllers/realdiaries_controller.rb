class RealdiariesController < ApplicationController

	before_action :set_real_diary, only: [:show]

	# リアル日記を作成or更新→ POST /realdiaries
	def create
		result = Realdiary.find_or_create_or_update(real_diary_params)
		if result[:success]
			render json: { message: result[:message] }, status: :ok
		else
			render json: { errors: result[:errors] }, status: :unprocessable_entity
		end
	end

	# リアル日記の一覧を表示→ GET /realdiaries
	def index
		@real_diaries = Realdiary.order(:date) # 日付の昇順（古い順）に並べる
		render json: @real_diaries, only: [:title, :date] #タイトルと日付を返す
	end

	#一覧から個別の日記を表示→ GET /realdiaries/:id
	def show
		render json: @real_diary #詳細情報を返す→フロントで:diaryを表示してもらう
	end

	private #controller内部でのみ使用するアクション

	# リクエストから受け取るパラメータを許可
	def real_diary_params
		params.require(:realdiary).permit(:title, :diary, :date, :user_id)
	end

	def set_real_diary
		@real_diary = Realdiary.find(params[:id])
	end
end
