Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  namespace :api do
    namespace :v1 do
      post '/tokens/new', to: 'tokens#create_access_token'
      post '/authorize', to: 'auth#authorize'
      post '/authenticate', to: 'auth#authenticate'
    end
  end
end
