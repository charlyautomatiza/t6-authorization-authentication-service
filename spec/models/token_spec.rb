require 'rails_helper'
require 'json'

RSpec.describe Token, type: :model do
  before do
    @url = "http://localhost:3000/api/v1/token"
    @headers = { "Content-type": "application/json" }
  end

  describe "POST /api/v1/token" do
    context "When user not found" do
      before do
        @body = { "id": "1" }
      end
      it "responds with :unprocessable_entity (422) status code" do
        post @url, params: @body.to_json, header: @headers

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "When user exists" do
      before do
        @user = User.create(username: "user_test", fullname: "User Test", email: "test@gmail.com", password: "test1234")
        @body = { "id": @user.id }
      end
      it "responds with :created (200) status code" do
        post @url, params: @body.to_json, header: @headers

        expect(response).to have_http_status(:created)
      end
    end
  end
end
