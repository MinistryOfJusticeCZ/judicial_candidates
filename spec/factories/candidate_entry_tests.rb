FactoryBot.define do
  factory :candidate_entry_test do
    entry_test
    association :candidate, factory: :candidate_invited_to_test
    points nil
    arrival nil
    apology nil
  end
end
