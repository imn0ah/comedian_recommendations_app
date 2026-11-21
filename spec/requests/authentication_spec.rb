
require 'rails_helper'

RSpec.describe "Authentication", type: :request do
  describe "POST /users" do
    it "ユーザー登録が正常にできる" do
      expect {
        post user_registration_path,
             params: {
               user: {
                 email: "test@example.com",
                 password: "password123",
                 password_confirmation: "password123"
               }
             }
      }.to change(User, :count).by(1)

      expect(response).to have_http_status(:redirect)
    end

    it "ユーザー登録に失敗する" do
      expect {
        post user_registration_path,
             params: {
               user: {
                 email: "",
                 password: "password123",
                 password_confirmation: "password123"
               }
             }
      }.to change(User, :count).by(0)
    end
  end

  describe "POST /users/sign_in" do
    it "ログインに成功する" do
      user = FactoryBot.create(:user)

      post user_session_path,
           params: {
             user: {
               email: user.email,
               password: "hogehoge"
             }
           }

      expect(response).to have_http_status(:redirect)

      get root_path
      expect(response.body).to include("ログアウト")
    end

    it "ログインに失敗する" do
      user = FactoryBot.create(:user)

      post user_session_path,
           params: {
             user: {
               email: user.email,
               password: ""
             }
           }

      expect(response).to have_http_status(:unprocessable_content)

      get root_path
      expect(response.body).not_to include("ログアウト")
    end
  end

  describe "DELETE /users/sign_out" do
    it "ログアウトに成功する" do
      user = FactoryBot.create(:user)

      post user_session_path,
           params: {
             user: {
               email: user.email,
               password: "hogehoge"
             }
           }

      delete destroy_user_session_path
      expect(response).to have_http_status(:redirect)

      get root_path
      expect(response.body).to include("ログイン")
      expect(response.body).not_to include("ログアウト")
    end
  end
end
