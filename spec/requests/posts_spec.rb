require 'rails_helper'

RSpec.describe "Posts", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get posts_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /posts" do
    context "ログインしている場合" do
      it "未登録の芸人に対して投稿ができる" do
        user = FactoryBot.create(:user)
        sign_in(user)

        expect {
          post posts_path, params: {
          comedian_name: "テスト",
          post: {
            content: "テストです"
          }
        }
        }.to change(Post, :count).by(1)
         .and change(Comedian, :count).by(1)

        expect(response).to redirect_to(posts_path)

        created_post = Post.last

        expect(created_post.user).to eq(user)
        expect(created_post.comedian.name).to eq("テスト")
        expect(created_post.content).to eq("テストです")
      end

      it "別ユーザーが投稿済みの芸人に対して投稿ができる" do
        first_post = FactoryBot.create(:post)
        second_user = FactoryBot.create(:user)
        sign_in(second_user)

        expect {
          post posts_path, params: {
            comedian_name: first_post.comedian.name,
            post: {
              content: "方言が面白い"
            }
          }
        }.to change(Post, :count).by(1).and change(Comedian, :count).by(0)

        expect(response).to redirect_to(posts_path)

        created_post = Post.last

        expect(created_post.user).to eq(second_user)
        expect(created_post.comedian).to eq(first_post.comedian)
        expect(created_post.content).to eq("方言が面白い")
      end

      it "芸人名が未入力の場合は投稿できない" do
        user = FactoryBot.create(:user)
        sign_in(user)

        expect {
          post posts_path, params: {
            comedian_name: "",
            post: {
              content: "投稿失敗"
            }
          }
        }.to change(Post, :count).by(0).and change(Comedian, :count).by(0)

        expect(response).to have_http_status(422)
        expect(response.body).to include("芸人名を入力してください")
      end

      it "おすすめ理由が未入力の場合は投稿できない" do
        user = FactoryBot.create(:user)
        sign_in(user)

        expect {
          post posts_path, params: {
            comedian_name: "投稿失敗",
            post: {
              content: ""
            }
          }
        }.to change(Post, :count).by(0).and change(Comedian, :count).by(0)

        expect(response).to have_http_status(422)
        expect(response.body).to include("おすすめ理由を入力してください")
      end

      it "同一ユーザーが同じ芸人に対して重複投稿できないこと" do
        first_post = FactoryBot.create(:post)
        sign_in(first_post.user)

        expect {
          post posts_path, params: {
            comedian_name: first_post.comedian.name,
            post: {
              content: first_post.content
            }
          }
        }.to change(Post, :count).by(0).and change(Comedian, :count).by(0)

        expect(response).to have_http_status(422)
        expect(response.body).to include("既にこの芸人の投稿はされています")
      end
    end
  end

  describe "GET /posts/new" do
    context "ログインしていない場合" do
      it "ログイン画面へリダイレクトされる" do
        get new_post_path

        expect(response).to redirect_to(new_user_session_path)
      end

      it "未ログイン時の投稿リクエストの制限" do
        expect {
          post posts_path, params: {
            comedian_name: "千原兄弟",
            post: {
              content: "飲み会でのMADお笑いが面白い"
            }
          }
        }.to change(Post, :count).by(0).and change(Comedian, :count).by(0)

        expect(response).to redirect_to(new_user_session_path)
      end

      it "未ログインでみんなのおすすめ一覧が閲覧できる" do
        get posts_path
        expect(response).to have_http_status(200)
      end
    end
  end
end
