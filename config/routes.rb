Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post '/generate_token', to: 'tokens#generate_token'
    end
  end
end
