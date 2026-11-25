require "rails_helper"

RSpec.describe "comedians", type: :request do
    describe "GET /comedians/:id" do
        it "対象の芸人の投稿を表示する" do
            first_post = FactoryBot.create(:post, content: "一発芸が面白い")
            second_post = FactoryBot.create(:post, comedian: first_post.comedian, content: "大喜利が上手")

            get comedian_path(first_post.comedian.id)
            expect(response.body).to include(first_post.content)
            expect(response.body).to include(second_post.content)
        end

        it "対象の芸人の名前が表示される" do
            comedian = FactoryBot.create(:comedian)

            get comedian_path(comedian.id)
            expect(response.body).to include(comedian.name)
        end

        it "他の芸人の投稿が表示されない" do
            first_post = FactoryBot.create(:post, content: "ツッコミが面白い")
            second_post = FactoryBot.create(:post, content: "ボケが面白い")

            get comedian_path(first_post.comedian_id)
            expect(response.body).to include(first_post.content)
            expect(response.body).not_to include(second_post.content)
        end

        it "投稿が最新投稿順に表示される" do
            first_post = FactoryBot.create(:post, content: "最高！！", created_at: 2.days.ago)
            second_post = FactoryBot.create(:post, comedian: first_post.comedian, content: "コントがシュール", created_at: 1.day.ago)

            get comedian_path(first_post.comedian.id)
            first_position = response.body.index(first_post.content)
            second_position = response.body.index(second_post.content)

            expect(first_position).to be > second_position
        end

        it "未ログインでも詳細ページを確認できる" do
            comedian = FactoryBot.create(:comedian)
            get comedian_path(comedian.id)
            expect(response).to have_http_status(200)
        end

        it "存在しないidを指定すると404になる" do
            get comedian_path(-1)

            expect(response).to have_http_status(404)
        end
    end
end
