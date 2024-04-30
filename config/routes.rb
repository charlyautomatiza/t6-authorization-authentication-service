Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  namespace :api do
    namespace :v1 do
      post '/tokens/new', to: 'tokens#create_access_token'
      post '/authorize', to: 'auth#authorize'
      scope '/auth' do
        post '/login_with_email', to: 'auth#login_with_email'
        post '/login_with_token', to: 'auth#login_with_token'
      end
    end
  end
end
