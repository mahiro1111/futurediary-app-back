class FuturediariesController < ApplicationController
	before_action :set_future_diary, only: [:show]

	# 未来日記の一覧を表示→ GET /futurediaries
	def index
		@future_diaries = Futurediary.find(params[:id]).order(:date) # 日付の昇順（古い順）に並べる
		render json: @future_diaries, only: [:title, :date] #タイトルと日付を返す
	end

	#一覧から個別の日記を表示→ GET /futurediaries/:id
	def show
		render json: @future_diary #詳細情報を返す→フロントで:diaryを表示してもらう
	end

	private #controller内部でのみ使用するアクション

	def set_future_diary
		@future_diary = Futurediary.find(params[:id])
	end
end
