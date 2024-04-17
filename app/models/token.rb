class Token < ApplicationRecord
  has_secure_token :token, length: 24

  belongs_to :user
  enum token_type: { authorization: "authorization", authentication: "authentication" }
end
