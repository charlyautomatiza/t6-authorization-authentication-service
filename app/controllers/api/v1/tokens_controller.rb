require 'openssl'

class Api::V1::TokensController < ApplicationController
  before_action :set_user, only: %i[ create_authorization_token create_authentication_token ]

  include Tokenizer
  include Authorizable
  include Authenticable

  private

  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    render json: {
      status: 422,
      errors: e.message
    }, status: :unprocessable_entity
  end
end
