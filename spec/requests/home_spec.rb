require 'rails_helper'

RSpec.describe "GET /", type: :request do
  describe "root_path" do
    it "returns http success" do
      get root_path
      expect(response).to have_http_status(:success)
    end

    it "AI推薦機能へ遷移するリンクが存在する" do
      get root_path
      expect(response).to have_http_status(:success)
      expect(response.parsed_body.at_css("a[href='/recommendations']")).not_to be_nil
    end

    it "みんなのおすすめへ遷移するリンクが存在する" do
      get root_path
      expect(response).to have_http_status(:success)
      expect(response.parsed_body.at_css("a[href='/posts']")).not_to be_nil
    end
  end
end
