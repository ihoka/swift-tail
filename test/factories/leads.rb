FactoryBot.define do
  factory :lead do
    from { "New York" }
    to { "Los Angeles" }
    email { "test@example.com" }
    phone { "+1 (555) 123-4567" }

    trait :with_different_cities do
      from { "Chicago" }
      to { "Miami" }
    end

    trait :with_different_contact do
      email { "another@example.com" }
      phone { "+1 (555) 987-6543" }
    end
  end
end
