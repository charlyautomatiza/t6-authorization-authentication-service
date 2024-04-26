module Authorizable
  extend ActiveSupport::Concern

  included do
    before_action :set_key_and_pass_phrase, only: %i[ create_authorization_token ]
    before_action :generate_token, only: %i[ create_authorization_token ]
  end

  def authorize
    auht_token = request.headers['Authorization']
    raise ActiveRecord::RecordNotFound if User.find_by(api_key: auht_token).nil?

    render json: {}, status: :ok
  rescue => _e
    render json: { status: 401 }, status: :unauthorized
  end

  def create_authorization_token
    if @user.update(api_key: @token)
      render json: { status: 201, message: "Token created successfully assigned to #{@user.username}", token: @user.api_key }, status: :created
    else
      render json: { status: 422, error: @token.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def set_key_and_pass_phrase
    @key = @user.id
    @pass_phrase = @user.username
  end

  def generate_token
    @token = OpenSSL::HMAC.hexdigest("SHA256", @key, @pass_phrase)
  rescue StandardError => e
    render json: {
      status: 422,
      error: e.message
    }, status: :unprocessable_entity
  end
end
