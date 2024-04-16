require 'openssl'

class Api::V1::TokensController < ApplicationController
  include Tokenizer

  before_action :set_user

  def generate_token
    encrypted_code = create_encrypted_code
    options = {
      secret_key: encrypted_code,
      algorithm: 'HS256',
      exp: 1.day.from_now
    }
    token = encode({username: @user.username, user_id: @user.id}, true, options)

    render json: { status: 201, message: "Token created successfully assigned to #{@user.username}", token: token }
  end

  private

  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    render json: {
      status: 422,
      errors: e.message
    }, status: :unprocessable_entity
  end

  def create_encrypted_code
    key = "apiAuthentication"
    pass_phrase = "SecretPhraseToAuthenticateAPIcalls"
    OpenSSL::HMAC.hexdigest("SHA256", key, pass_phrase)
  end
end
