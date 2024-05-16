FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "#{Faker::Lorem.word}_#{n}" }
  end
end