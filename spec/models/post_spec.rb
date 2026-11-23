require 'rails_helper'

RSpec.describe Post, type: :model do
  it "投稿が正常にできる" do
    expect(FactoryBot.build(:post)).to be_valid
  end

  it "芸人名指定されていない場合は投稿できない" do
    post = FactoryBot.build(:post, comedian: nil)
    expect(post).to be_invalid
  end

  it "投稿内容が空の場合は投稿できない" do
    post = FactoryBot.build(:post, content: "")
    expect(post).to be_invalid
  end

  it "同じユーザーが同じ芸人の投稿を重複して投稿できない" do
    first_post = FactoryBot.create(:post)
    second_post = FactoryBot.build(
      :post,
      user: first_post.user,
      comedian: first_post.comedian
    )
    expect(second_post).to be_invalid
  end

  it "別ユーザーが同じ芸人に投稿ができる" do
    first_post = FactoryBot.create(:post)
    second_post = FactoryBot.build(
      :post,
      comedian: first_post.comedian
    )
    expect(second_post).to be_valid
  end
end
