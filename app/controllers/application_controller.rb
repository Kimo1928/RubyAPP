class ApplicationController < ActionController::API
  def encode_token(payload)
    JWT.encode(payload, Rails.application.credentials.secret_key_base)
  end

  def auth_header
    request.headers['Authorization']
  end

  def decoded_token
    if auth_header
      token = auth_header.split(' ')[1]
      JWT.decode(token, Rails.application.credentials.secret_key_base, true, algorithm: 'HS256')
    end
  rescue
    nil
  end

  def current_user
    if decoded_token
      user_id = decoded_token[0]['user_id']
      @current_user ||= User.find_by(id: user_id)
    end
  end

  def authorized
    render json: { message: 'Please log in' }, status: :unauthorized unless current_user
  end
end
