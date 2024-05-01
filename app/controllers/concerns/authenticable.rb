module Authenticable
  extend ActiveSupport::Concern

  included do
    before_action :set_params, only: %i[ login_with_email login_with_token ]
    before_action :invalid_params?, only: %i[ login_with_email login_with_token ]
  end

  def login_with_email
    raise ActiveRecord::RecordNotFound if User.find_by(email: @email, password: @password).nil?
    render json: {}, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: {}, status: :unauthorized
  end

  def login_with_token
    raise ActiveRecord::RecordNotFound if User.find_by(api_key: @token).nil?
    render json: {}, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: {}, status: :unauthorized
  end

  private

  def set_params
    @token = params['auth_token']
    @email = params['email']
    @password = params['password']
  rescue ActionDispatch::Http::Parameters::ParseError => e
    render json: {message: e.message}, status: :unprocessable_entity
  end

  def invalid_params?
    render json: { message: "You must pass a token param or email and password params" }, status: :unprocessable_entity if @token.nil? && (@email.nil? || @password.nil?)
  end
end
