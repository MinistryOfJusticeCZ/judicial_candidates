FactoryBot.create_list(:candidate, 15)

# One unconfirmed test
FactoryBot.create(:entry_test, capacity: 5)

# Confirmed test with invited candidates
2.times do |i|
  et = FactoryBot.create(:entry_test, :listed, capacity: 5)
  FactoryBot.create_list(:candidate, et.capacity, :invited_to_test, entry_test: et)
end

# Candidates ready to be invited for interview
et = FactoryBot.create(:entry_test, :evaluated, capacity: 15)
FactoryBot.create_list(:candidate, 2,                   :for_interview, entry_test: et, organizations: [1])
FactoryBot.create(:candidate, 1, :for_interview, entry_test: et, organizations: [1])
FactoryBot.create_list(:candidate, et.capacity / 3 - 3, :for_interview, entry_test: et, organizations: [2,3])
FactoryBot.create_list(:candidate, et.capacity / 3,     :for_interview, entry_test: et, organizations: [2])
FactoryBot.create_list(:candidate, et.capacity / 3,     :for_interview, entry_test: et, organizations: [3])
