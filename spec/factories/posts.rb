FactoryBot.define do
  factory :post do
    comedian { nil }
    user { nil }
    content { "MyText" }
  end
end
