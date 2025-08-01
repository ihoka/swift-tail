FactoryBot.define do
  factory :super_user do
    name { "Super Admin" }
    sequence(:email) { |n| "admin#{n}@example.com" }
    password { "admin123456" }
    password_confirmation { "admin123456" }

    trait :with_different_name do
      name { "Another Admin" }
    end
  end
end
