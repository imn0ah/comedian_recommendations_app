FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "hogehoge" }
    password_confirmation { "hogehoge" }
  end
end
