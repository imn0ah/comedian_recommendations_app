FactoryBot.define do
  factory :post do
    association :comedian
    association :user
    content { "この芸人の漫才面白かった" }
  end
end
