require 'rails_helper'
require 'json'

RSpec.describe "TokenControllers", type: :request do
  before do
    @generate_token_endpoint = "http://localhost:3000/api/v1/generate_token"
    @params = { "id": "55e70916-8939-4fb3-a3a1-b67e726c26a8" }
    @headers = { "Content-type": "application/json" }
  end

  describe "GET /api/v1/generate_token" do
    context "On set_key_and_pass_phrase" do
      it "creates key and pass_phrase" do
        tokenInstance = Api::V1::TokensController.new
        tokenInstance.send(:set_key_and_pass_phrase)

        expect(tokenInstance.instance_variable_get(:@key).class).to eq(String)
        expect(tokenInstance.instance_variable_get(:@pass_phrase).class).to eq(String)
      end
    end

    context "On encrypted code fails" do
      it "rsponds with status unprocessable_entity" do
        post @generate_token_endpoint, params: @params.to_json, headers: @haders

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "On encrypted code success" do
      it "creates an encrypted code" do
        encrypted_code = Api::V1::TokensController.new
        encrypted_code.send(:set_key_and_pass_phrase)
        code = encrypted_code.send(:create_encrypted_code)

        expect(code.class).to eq(String)
      end
    end

    context "When user not found" do
      it "responds with unprocessable_entity" do
        post @generate_token_endpoint, params: @params.to_json, headers: @headers

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "responds with unprocessable_entity in the response and error message" do
        post @generate_token_endpoint, params: @params.to_json, headers: @headers

        resp_body = HashWithIndifferentAccess.new(JSON.parse(response.body))

        expect(resp_body[:status]).to eq(422)
        expect(resp_body[:errors]).to eq("Couldn't find User with 'user_id'=55e70916-8939-4fb3-a3a1-b67e726c26a8")
      end
    end

    context "On success response" do
      before do
        User.create(user_id: "55e70916-8939-4fb3-a3a1-b67e726c26a8", email: 'mauricionc19@gmail.com', email_confirmed: false, fullname: 'Mauricio Navarro', password: 'Mauricion123', username: 'MauricioNC')
      end

      it "responds with created as status code with success message" do
        post @generate_token_endpoint, params: @params.to_json, headers: @headers

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['status']).to eq(201)
        expect(JSON.parse(response.body)['message']).to eq("Token created successfully assigned to MauricioNC")
      end
    end
  end
end
