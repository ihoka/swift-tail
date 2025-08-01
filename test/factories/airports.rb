FactoryBot.define do
  factory :airport do
    name { "Test Airport" }
    sequence(:icao_code) { |n| "T#{n.to_s.rjust(3, '0')}" }
    sequence(:iata_code) { |n| "T#{n.to_s.rjust(2, '0')}" }
    private_jet_capable { true }
    country_code { "US" }
    type { "medium_airport" }

    trait :large_airport do
      type { "large_airport" }
      name { "Large International Airport" }
    end

    trait :small_airport do
      type { "small_airport" }
      private_jet_capable { false }
    end

    trait :without_iata do
      iata_code { nil }
    end
  end
end
