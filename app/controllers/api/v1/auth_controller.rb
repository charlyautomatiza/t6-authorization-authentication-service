class Api::V1::AuthController < ApplicationController
  include Authorizable
  include Authenticable
end
