require 'jwt'

module Tokenizer
  JWT_SECRET = Rails.application.config.secret_key_base.to_s

  def encode(payload, signed = false, options)
    payload[:exp] = options[:exp].to_i
    return JWT.encode payload, nil, 'none' unless signed

    JWT.encode payload, options[:secret_key], options[:algorithm]
  end

  def decode(token, options)
    decoded_token = JWT.decode(token, options[:secret_key], true, { algorithm: options[:algorithm] })
    user = decoded_token[0]['user_id']
    User.find(user)
  rescue => _e
    nil
  end
end
