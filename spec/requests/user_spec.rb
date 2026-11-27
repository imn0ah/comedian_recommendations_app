require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /user" do
    it "マイページのレスポンス取得が成功する" do
      user = FactoryBot.create(:user)
      sign_in(user)

      get user_path
      expect(response).to have_http_status(200)
    end

    it "ログイン中のユーザー自身の投稿が表示される" do
      first_user = FactoryBot.create(:user)
      post = FactoryBot.create(:post, user: first_user, content: "楽しい")
      sign_in(first_user)

      get user_path
      expect(response.body).to include(post.comedian.name)
      expect(response.body).to include(post.content)
    end

    it "他人の投稿が表示されない" do
      first_user = FactoryBot.create(:user)
      first_post = FactoryBot.create(:post, user: first_user, content: "楽しい")
      second_user = FactoryBot.create(:user)
      second_post = FactoryBot.create(:post, user: second_user, content: "シュールなお笑い")
      sign_in(first_user)

      get user_path
      expect(response.body).to include(first_post.comedian.name)
      expect(response.body).to include(first_post.content)
      expect(response.body).not_to include(second_post.content)
    end

    it "未ログイン時はログイン画面へリダイレクトされる" do
      get user_path
      expect(response).to redirect_to(new_user_session_path)
    end

    it "投稿が新着順に表示される" do
      user = FactoryBot.create(:user)
      first_post = FactoryBot.create(:post, user: user, content: "面白い", created_at: 2.days.ago)
      second_post = FactoryBot.create(:post, user: user, content: "感動", created_at: 1.day.ago)
      sign_in(user)

      get user_path
      first_position = response.body.index(first_post.content)
      second_position = response.body.index(second_post.content)

      expect(first_position).to be > second_position
    end

    it "投稿編集画面のリンクが表示される" do
      user = FactoryBot.create(:user)
      post = FactoryBot.create(:post, user: user)
      sign_in(user)

      get user_path
      expect(Capybara.string(response.body)).to have_link("編集する", href: edit_post_path(post.id))
    end

    it "投稿が存在しない場合も正常に表示される" do
      user = FactoryBot.create(:user)
      sign_in(user)

      get user_path
      expect(response).to have_http_status(:success)
      expect(Capybara.string(response.body)).to have_selector("h1", text: "マイページ")
      expect(Capybara.string(response.body)).not_to have_link("編集する")
    end
  end
end
