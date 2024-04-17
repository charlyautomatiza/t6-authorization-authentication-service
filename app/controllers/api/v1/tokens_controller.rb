require 'openssl'

class Api::V1::TokensController < ApplicationController
  include Tokenizer

  before_action :set_user
  before_action :remove_current_token, only: [:create_token]

  def create_token
    generate_authentication_token if params[:token_type] == 'authentication'
    generate_authorization_token if params[:token_type] == 'authorization'
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

  def set_key_and_pass_phrase
    @key = "keyForTokenAuthorizationAndAuthentication"
    @pass_phrase = "SecretPhraseToAuthenticateAndAuthorizeAPIcalls"
  end

  def create_encrypted_code
    @encrypted_code = OpenSSL::HMAC.hexdigest("SHA256", @key, @pass_phrase)
  rescue StandardError => e
    render json: {
      status: 422,
      errors: [
        "Something went wrong, please try again",
        e.message
      ]
    }, status: :unprocessable_entity
  end

  def generate_authentication_token
    @token = @user.tokens.build(token_type: params[:token_type])

    if @token.save
      render json: {
        status: 201,
        message: "Token was successfully created and assigned to user #{@user.username}",
        token: @token.token
      }, status: :created
    end
  rescue ActiveRecord::RecordNotSaved => e
    render json: {
      status: 422,
      error: e.message
    }, status: :unprocessable_entity
  end

  def generate_authorization_token
    set_key_and_pass_phrase
    create_encrypted_code

    options = {
      secret_key: @encrypted_code,
      algorithm: 'HS256',
      exp: 1.day.from_now
    }
    token = encode({ user_id: @user.id, username: @user.username }, true, options)

    @token = @user.tokens.build(token: token, token_type: params[:token_type])

    if @token.save
      render json: { status: 201, message: "Token created successfully assigned to #{@user.username}", token: token }, status: :created
    else
      render json: { status: 422, error: @token.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def remove_current_token
    @user.tokens.find_by_token_type(params[:token_type]).delete unless @user.tokens.find_by_token_type(params[:token_type]).nil?
  end
end
