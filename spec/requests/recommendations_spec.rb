require 'rails_helper'

RSpec.describe "Recommendations", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get recommendations_path
      expect(response).to have_http_status(:success)
    end
  end
end
