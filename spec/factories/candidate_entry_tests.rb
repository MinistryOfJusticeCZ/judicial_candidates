FactoryBot.define do
  factory :candidate_entry_test do
    entry_test
    association :candidate, factory: :candidate_invited_to_test
    points nil
    arrival 'arrived'
    apology nil

    before(:create) do |evaluator, model|
      model.candidate.state = 'invited_to_test'
    end
  end
end
