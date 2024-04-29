module Authorizable
  extend ActiveSupport::Concern

  def authorize
    auht_token = request.headers['Authorization']
    raise ActiveRecord::RecordNotFound if  User.where.not(api_key: nil).find_by(api_key: auht_token).nil?

    render json: {}, status: :ok
  rescue => _e
    render json: { status: 401 }, status: :unauthorized
  end
end
