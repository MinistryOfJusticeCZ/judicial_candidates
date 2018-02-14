FactoryBot.define do
  factory :entry_test do
    time { Time.now - 2.months }
    capacity 5
    place 1

    to_create {|instance| instance.save(validate: false) }
  end
end
