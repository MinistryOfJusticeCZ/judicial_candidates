FactoryBot.define do
  factory :candidate do
    transient do
      test_points { nil }
      entry_test { nil }
    end

    association :user, factory: :egov_utils_user
    state { 'for_entry_test' }
    birth_date { Date.new(1992, 1, 1) }
    phone { '+420604123123' }
    university { 1 }
    graduation_year { 2015 }
    higher_title { 'Doc.' }
    organizations { [2] }
    suborganizations { [] }
    diploma { Rails.root.join('spec', 'data', 'justice-enter.jpg') }
    shorter_invitation { false }
    agreed_limitations { true }
    position { nil }


    trait :invited_to_test do
      state { 'invited_to_test' }
      entry_test { FactoryBot.create(:entry_test, :listed) }
    end

    trait :for_interview do
      state { 'waiting' }
      test_points { Random.rand(100) }
      entry_test { FactoryBot.create(:entry_test, :evaluated) }

      after(:create) do |candidate, evaluator|
        candidate.candidate_entry_tests.create(entry_test_id: evaluator.entry_test.id, points: evaluator.test_points)
      end
    end

    factory :candidate_invited_to_test, traits: [:invited_to_test]
  end
end
