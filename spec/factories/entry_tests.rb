FactoryBot.define do
  factory :entry_test do
    time { Time.now + 2.months }
    capacity 2
    place 1
    state 'unconfirmed'

    #allow tests in past
    to_create {|instance| instance.save(validate: false) }
  end
end
