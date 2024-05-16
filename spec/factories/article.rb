FactoryBot.define do
    factory :article do
        title { Faker::Lorem.word }
        body { Faker::Lorem.sentence }
        status { ["draft", "published"].sample }
        category
        trait :draft do
            status { :draft }
        end
        trait :published do
            status { :published }
        end
    end
  end