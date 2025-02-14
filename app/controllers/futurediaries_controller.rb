class FuturediariesController < ApplicationController
	before_action :set_future_diary, only: [:show]

	# 未来日記の一覧を表示→ GET /futurediaries
	def index
		@future_diaries = Futurediary.find(params[:user_id]).order(:date) # 日付の昇順（古い順）に並べる
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


#ここから追加分
def create
  # Googleカレンダーから当日の予定を取得
  schedule = get_google_calendar_schedule(params[:user_id])

  # 日本語の予定を英語に翻訳
  translated_schedule = translate(schedule)

  # OpenAIで未来日記を作成
  client = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])

  response = client.chat(
    parameters: {
      model: "gpt-3.5-turbo",
      messages: [{ role: "system", content: "以下の予定を元に未来日記を書いてください。" }, { role: "user", content: translated_schedule }],
      temperature: 0.7,
      max_tokens: 300
    }
  )

  diary_english = response.dig("choices", 0, "message", "content")

  # 英語の未来日記を日本語に翻訳
  diary_japanese = translate(diary_english)

  # Futurediaryに保存
  future_diary = Futurediary.create(
    title: schedule,
    diary: diary_japanese,
    date: Date.today,
    user_id: params[:user_id]
  )

  render json: future_diary
end

private

#Faraday で Google Apps Script を叩く
def translate(text)
  original_url = ''
  url_with_query = "#{original_url}?text=#{text}&source=ja&target=en"

  conn = Faraday.new(url: url_with_query)
  response = conn.get

  if response.status == 302
    redirect_url = response.headers['Location']
    conn = Faraday.new
    response = conn.get(redirect_url)
    if response.success?
      JSON.parse(response.body)['text']
    else
      ""
    end
  else
    ""
  end
end
end


end
