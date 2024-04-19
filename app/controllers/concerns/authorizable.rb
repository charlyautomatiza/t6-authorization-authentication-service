module Authorizable
  extend ActiveSupport::Concern

  included do
    before_action :set_key_and_pass_phrase, only: %i[ create_authorization_token ]
    before_action :create_encrypted_code, only: %i[ create_authorization_token ]
    before_action :set_options, only: %i[ create_authorization_token ]
    before_action :set_jwt_body, only: %i[ create_authorization_token ]
  end

  def create_authorization_token
    jwt_token = encode(@jwt_body, true, @options)
    @token = @user.tokens.build(token: jwt_token, token_type: 'authorization')

    if @token.save
      render json: { status: 201, message: "Token created successfully assigned to #{@user.username}", token: @token.token }, status: :created
    else
      render json: { status: 422, error: @token.errors.full_messages }, status: :unprocessable_entity
    end
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
      error: e.message
    }, status: :unprocessable_entity
  end

  def set_options
    @options = { secret_key: @encrypted_code, algorithm: 'HS256', exp: 1.day.from_now }
  end

  def set_jwt_body
    @jwt_body = { user_id: @user.id, username: @user.username }
  end
end
