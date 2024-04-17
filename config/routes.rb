Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post '/generate_token', to: 'tokens#generate_token'
      post '/tokens/:token_type', to: 'tokens#create_token'
    end
  end
end
