FactoryBot.define do
  factory :entry_test do
    time { Time.now + 2.months }
    capacity { 2 }
    place { 1 }
    state { 'unconfirmed' }

    trait :listed do
      state { 'listed' }
    end

    trait :past do
      state { 'passed' }
      time { Time.now - 10.days }
    end

    trait :evaluated do
      state { 'evaluated' }
      time { Time.now - 10.days }
    end

    #allow tests in past
    to_create {|instance| instance.save(validate: false) }
  end
end
