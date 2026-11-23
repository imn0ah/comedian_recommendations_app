FactoryBot.define do
  factory :comedian do
    sequence(:name) { |n| "芸人#{n}" }
  end
end
