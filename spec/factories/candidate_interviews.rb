FactoryBot.define do
  factory :candidate_interview do
    interview
    state { 'invited' }
  end
end
