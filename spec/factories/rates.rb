FactoryBot.define do
  factory :rate do
    cleanliness { 5 }
    information { 5 }
    location { 5 }
    communication { 5 }
    recommendation { 5 }
    price { 5 }
    price_category { 1 }
    award { false }

    association :room
    association :user
  end
end
