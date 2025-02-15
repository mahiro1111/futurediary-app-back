class SchedulesController < ApplicationController
  require 'google-id-token'

  def events
    token = params[:token]
    date = params[:date]

    # ユーザーを取得し、イベントを保存する処理→userモデル
    begin
      user = User.find_by_email_from_token(token)
      if user.nil?
        render json: { error: 'User not found' }, status: :unauthorized
        return
      end

      # モデルでイベントを取得して保存→scheduleモデル
      saved_events = Schedule.save_google_calendar_events(user, date, token)

      if saved_events.empty?
        render json: { message: 'No events found for the specified date.' }, status: :ok
      else
        render json: saved_events, status: :ok
      end
    rescue Google::Apis::ClientError => e
      render json: { error: 'Google API Client Error', message: e.message }, status: :bad_request
    rescue Google::Apis::AuthorizationError => e
      render json: { error: 'Google API Authorization Error', message: e.message }, status: :unauthorized
    rescue StandardError => e
      render json: { error: 'Internal Server Error', message: e.message }, status: :internal_server_error
    end
  end
end
