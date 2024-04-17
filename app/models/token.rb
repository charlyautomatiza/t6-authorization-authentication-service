class Token < ApplicationRecord
  belongs_to :user
  enum token_type: { authorization: "authorization", authentication: "authentication" }
end
