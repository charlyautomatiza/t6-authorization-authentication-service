module Authenticable
  extend ActiveSupport::Concern

  included do
    before_action :set_params, only: %i[ authenticate ]
    before_action :invalid_params?, only: %i[ authenticate ]
  end

  def authenticate
    if @token
      raise ActiveRecord::RecordNotFound if User.find_by(api_key: @token).nil?
    else
      raise ActiveRecord::RecordNotFound if User.find_by(username: @username, email: @email).nil?
    end

    render json: {}, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: {}, status: :unauthorized
  end

  private

  def set_params
    @token = params['auth_token']
    @email = params['email']
    @password = params['password']
  end

  def invalid_params?
    render json: { message: "You must pass a token param or email and password params" }, status: :unprocessable_entity if @token.nil? && @email.nil? && @password.nil?
  end
end
