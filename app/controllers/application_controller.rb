class ApplicationController < ActionController::Base
	rescue_from Google::Apis::ClientError, with: :handle_google_api_error
  rescue_from Google::Apis::AuthorizationError, with: :handle_google_auth_error
  rescue_from StandardError, with: :handle_standard_error

  private

  def handle_google_api_error(exception)
    render json: { error: 'Google API error', message: exception.message }, status: :unprocessable_entity
  end

  def handle_google_auth_error(exception)
    render json: { error: 'Google authentication error', message: exception.message }, status: :unauthorized
  end

  def handle_standard_error(exception)
    render json: { error: 'Internal server error', message: exception.message }, status: :internal_server_error
  end
end
