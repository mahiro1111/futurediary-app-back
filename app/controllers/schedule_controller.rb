class ScheduleController < ApplicationController
	require 'google/apis/calendar_v3'
	require 'google-id-token'

  def events
    token = params[:token]  # フロントエンドから送信されたGoogle IDトークン
    date = params[:date]    # フロントエンドから送信された日付（例: '2025-02-14'）

    validator = GoogleIDToken::Validator.new

    begin
      # GoogleのクライアントIDでトークンを検証
      payload = validator.check(token, 'YOUR_GOOGLE_CLIENT_ID')

      # ユーザー情報をデータベースから取得
      user = User.find_by(email: payload['email'])

      #ユーザー情報がなかったらエラーを返す
      if user.nil?
        render json: { error: 'User not found' }, status: :unauthorized
        return
      end

      # Google Calendar APIのサービスを作成
      service = Google::Apis::CalendarV3::CalendarService.new
      service.authorization = token  # フロント側から渡されたトークンを設定

      # 日付の開始と終了のタイムスタンプを計算
      start_time = DateTime.parse(date).beginning_of_day
      end_time = start_time.end_of_day

      # Google Calendar APIを使用して指定された日のイベントを取得
      events = service.list_events(
        'primary',
        time_min: start_time.iso8601,
        time_max: end_time.iso8601,
        single_events: true,
        order_by: 'startTime'
      )

      # イベントがない場合の処理
      if events.items.empty?
        render json: { message: 'No events found for the specified date.' }, status: :ok
      else
        # イベント情報をJSONで返す
        render json: events.items.map { |event|
          {
            title: event.summary,
            start_time: event.start.date_time,
            end_time: event.end.date_time
          }
        }, status: :ok
      end

    #エラー処理
    rescue Google::Apis::ClientError => e
      handle_google_api_error(e)
    rescue Google::Apis::AuthorizationError => e
      handle_google_auth_error(e)
    rescue StandardError => e
      handle_standard_error(e)
    end
  end
end
