FactoryBot.define do
  factory :rate do
    cleanliness { 5 }
    information { 5 }
    location { 5 }
    communication { 5 }
    recommendation { 5 }
    price { 5 }
    score { 5 }
    price_range { 1 }
    award { false }

    association :reservation
    user { reservation.guest }
    room { reservation.room }
  end
end
