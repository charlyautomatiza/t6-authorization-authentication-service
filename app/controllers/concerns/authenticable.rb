module Authenticable
  extend ActiveSupport::Concern

  def create_authentication_token
    @token = @user.tokens.build(token_type: 'authentication')

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

  def authenticate
    token = params['auth_token']
    user_data = params['user_data']
    
    raise StandardError.new "Invalid token or user data" if token.nil? && user_data.nil?

    if token
      raise ActiveRecord::RecordNotFound if User.find_by(api_key: token).nil?
    else
      raise ActiveRecord::RecordNotFound if User.find_by(user_name: user_data.username, email: user_data.email).nil?
    end

    render json: {}, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: {}, status: :unauthorized
  rescue StandardError => e
    render json: { message: e.message }, status: :unprocessable_entity
  end
end
