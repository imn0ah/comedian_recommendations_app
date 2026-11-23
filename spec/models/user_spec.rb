require 'rails_helper'

RSpec.describe User, type: :model do
  it "正常なユーザー情報が登録できるか" do
    expect(FactoryBot.build(:user)).to be_valid
  end

  it "メールアドレスが空欄の場合" do
    user = FactoryBot.build(:user, email: nil)
    user.valid?
    expect(user.errors[:email]).to be_present
  end

  it "メールアドレスが重複している場合" do
    FactoryBot.create(:user, email: "test@example.com")
    user = FactoryBot.build(:user, email: "test@example.com")

    expect(user).to be_invalid
  end

  it "メールアドレスの形式が不正" do
    user = FactoryBot.build(:user, email: "aaaa")
    user.valid?
    expect(user.errors[:email]).to be_present
  end

  it "パスワードが空欄" do
    user = FactoryBot.build(:user, password: nil)
    user.valid?
    expect(user.errors[:password]).to be_present
  end

  it "パスワードが六文字未満" do
    user = FactoryBot.build(:user, password: "12345", password_confirmation: "12345")
    user.valid?
    expect(user.errors[:password]).to be_present
  end

  it "パスワードと確認用パスワードが一致しない場合" do
    user = FactoryBot.build(:user, password_confirmation: "different")
    user.valid?
    expect(user.errors[:password_confirmation]).to be_present
  end

  it "ユーザーが複数の投稿を持てる" do
    user = FactoryBot.create(:user)
    FactoryBot.create(:post, user: user)
    FactoryBot.create(:post, user: user)

    expect(user.posts.count).to eq(2)
  end
end
