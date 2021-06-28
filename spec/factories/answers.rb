FactoryBot.define do
  factory :answer do
    body { "MyAnswer" }
    question { nil }

    trait :invalid do
      body { nil }
    end

  end
end
