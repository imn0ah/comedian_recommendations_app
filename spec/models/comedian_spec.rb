require 'rails_helper'

RSpec.describe Comedian, type: :model do
  it "nameカラムが空欄の場合は無効である" do
    comedian = Comedian.new(name: "")
    expect(comedian).not_to be_valid
  end

  it "nameカラムが重複している場合は無効である" do
    Comedian.create!(name: "サンドウィッチマン")

    comedian = Comedian.new(name: "サンドウィッチマン")
    expect(comedian).not_to be_valid
  end

  it "正しい芸人名を入力した場合に有効になること" do
    comedian = Comedian.new(name: "サンドウィッチマン")
    expect(comedian).to be_valid
  end

  it "芸人が複数の投稿を持てる" do
    comedian = FactoryBot.create(:comedian)

    FactoryBot.create(:post, comedian: comedian)
    FactoryBot.create(:post, comedian: comedian)

    expect(comedian.posts.count).to eq(2)
  end
end
