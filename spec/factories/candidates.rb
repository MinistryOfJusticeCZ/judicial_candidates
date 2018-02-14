FactoryBot.define do
  factory :candidate do
    association :user, factory: :egov_utils_user
    state 'for_entry_test'
    birth_date "1991-11-15"
    phone "+420604123123"
    university 1
    graduation_year 2015
    higher_title "Doc."
    organizations ['204000']
    suborganizations []
    diploma { Rails.root.join('spec', 'data', 'justice-enter.jpg') }
    shorter_invitation false
    agreed_limitations true

    trait :for_interview do
      state 'waiting'

      transient do
        test_points{ Random.rand(100) }
        entry_test{ FactoryBot.create(:entry_test) }
      end

      after(:create) do |candidate, evaluator|
        candidate.candidate_entry_tests.create(entry_test_id: evaluator.entry_test.id, points: evaluator.test_points)
      end
    end

    to_create {|instance| instance.save(validate: false) }
  end
end
