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
end
