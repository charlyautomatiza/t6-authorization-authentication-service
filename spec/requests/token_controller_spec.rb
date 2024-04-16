require 'rails_helper'
require 'json'

RSpec.describe "TokenControllers", type: :request do
  describe "GET /api/v1/55e70916-8939-4fb3-a3a1-b67e726c26a8/generate_token" do
    context "Success response" do
      before do
        User.create(user_id: "55e70916-8939-4fb3-a3a1-b67e726c26a8", email: 'mauricionc19@gmail.com', email_confirmed: false, fullname: 'Mauricio Navarro', password: 'Mauricion123', username: 'MauricioNC')
      end

      it "responds with ok and success message status code" do
        get "http://localhost:3000/api/v1/users/55e70916-8939-4fb3-a3a1-b67e726c26a8/generate_token"

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['status']).to eq(201)
        expect(JSON.parse(response.body)['message']).to eq("Token created successfully assigned to MauricioNC")
      end
    end

    context "User not found" do
      it "responds with unprocessable_entity when the user is not found" do
        get "http://localhost:3000/api/v1/users/55e70916-8939-4fb3-a3a1-b67e726c26a9/generate_token"

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "responds with unprocessable_entity in the response and error message" do
        get "http://localhost:3000/api/v1/users/55e70916-8939-4fb3-a3a1-b67e726c26a9/generate_token"

        expect(JSON.parse(response.body)['status']).to eq(422)
        expect(JSON.parse(response.body)['errors']).to eq("Couldn't find User with 'user_id'=55e70916-8939-4fb3-a3a1-b67e726c26a9")
      end
    end
  end
end
