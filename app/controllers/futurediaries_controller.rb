class FuturediariesController < ApplicationController
	before_action :set_future_diary, only: [:show]

	# 未来日記の一覧を表示 → GET /futurediariesuser_id=xxx
  def index
    @future_diaries = Futurediary.where(user_id: params[:user_id]).order(:date) # 日付の昇順
    render json: @future_diaries, only: [:diary, :date] # タイトルと日付のみ返す
  end

  # 個別の日記を表示 → GET /futurediaries/:id
  def show
    render json: @future_diary # 詳細情報を返す
  end

  # 未来日記の作成 → POST /futurediaries
  def create
    user_id = params[:user_id]
    today = Date.today

    #Scheduleモデルから当日の予定を取得
    schedules = Schedule.where(user_id: user_id, date: today).pluck(:summary) # summary だけ取得

    if schedules.empty?
      render json: { error: "予定が見つかりません" }, status: :not_found
      return
    end

    # 予定を `, ` で連結
    schedule_text = schedules.join(", ")

  # 日本語の予定を英語に翻訳
  translated_schedule = translate(schedule_text)

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
    title: schedule_text,
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
