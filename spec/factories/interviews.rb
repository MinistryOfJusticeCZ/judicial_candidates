FactoryBot.define do
  factory :interview do
    time { Time.now + 2.months }
    region_court { 1 }
    address { nil }
    boundary { 10 }
  end
end
