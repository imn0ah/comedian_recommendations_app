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

      it "自身の投稿内容を編集できること" do
        first_post = FactoryBot.create(:post, content: "モノマネ上手")
        sign_in(first_post.user)

        post_params = { content: "意外と大喜利強い" }

        patch post_path(first_post.id), params: { post: post_params }
        expect(first_post.reload.content).to eq("意外と大喜利強い")
        expect(response).to redirect_to(comedian_path(first_post.comedian.id))
        expect(flash[:notice]).to eq("編集しました")
      end

      it "他人の投稿内容を編集できない" do
        first_post = FactoryBot.create(:post, content: "モノマネ上手")
        other_user = FactoryBot.create(:user)
        sign_in(other_user)

        post_params = { content: "投稿内容が変更できない" }

        patch post_path(first_post.id), params: { post: post_params }
        expect(first_post.reload.content).to eq("モノマネ上手")
        expect(response).to redirect_to(posts_path)
        expect(flash[:alert]).to eq("指定された投稿は編集できません")
      end

      it "無効な編集内容を保存できない" do
        first_post = FactoryBot.create(:post, content: "お腹千切れるくらい面白い")
        sign_in(first_post.user)

        post_params = { content: "" }

        patch post_path(first_post.id), params: { post: post_params }
        expect(first_post.reload.content).to eq("お腹千切れるくらい面白い")
        expect(response).to have_http_status(422)
        expect(response.body).to include("おすすめ理由を入力してください")
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

      it "投稿が存在する芸人が一覧に表示される" do
        post = FactoryBot.create(:post)
        get posts_path
        expect(response.body).to include(post.comedian.name)
      end

      it "投稿が存在しない芸人は表示されない" do
        comedian = FactoryBot.create(:comedian)
        get posts_path
        expect(response.body).not_to include(comedian.name)
      end

      it "同じ芸人が重複して表示されない" do
        first_post = FactoryBot.create(:post)
        FactoryBot.create(:post, comedian: first_post.comedian)
        get posts_path
        expect(response.body.scan(first_post.comedian.name).count).to eq(1)
      end

      it "各芸人の最新投稿日時が新しい順に表示される" do
        first_post = FactoryBot.create(:post, created_at: 3.days.ago)
        second_post = FactoryBot.create(:post, created_at: 2.days.ago)
        FactoryBot.create(:post, comedian: first_post.comedian, created_at: 1.day.ago)

        get posts_path
        first_position = response.body.index(first_post.comedian.name)
        second_position = response.body.index(second_post.comedian.name)
        expect(first_position).to be < second_position
      end

      it "各芸人の最新のおすすめ理由が表示される" do
        first_post = FactoryBot.create(:post, content: "漫才が面白い", created_at: 2.days.ago)
        FactoryBot.create(:post, comedian: first_post.comedian, content: "トークが面白い", created_at: 1.day.ago)

        get posts_path
        expect(response.body).to include("トークが面白い")
        expect(response.body).not_to include("漫才が面白い")
      end
    end
  end
end
