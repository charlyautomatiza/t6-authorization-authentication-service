Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  namespace :api do
    namespace :v1 do
      post '/tokens/authentication', to: 'tokens#create_authentication_token'
      post '/tokens/authorization', to: 'tokens#create_authorization_token'
      post '/authorize', to: 'tokens#authorize'
    end
  end
end
