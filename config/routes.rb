Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get '/users/:id/generate_token', to: 'tokens#generate_token'
    end
  end
end
