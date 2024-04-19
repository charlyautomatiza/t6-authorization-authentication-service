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
end
