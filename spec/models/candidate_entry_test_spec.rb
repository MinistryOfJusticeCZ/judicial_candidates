require 'rails_helper'

RSpec.describe CandidateEntryTest, type: :model do
  let(:entry_test){ FactoryBot.create(:entry_test, capacity: 1) }

  describe 'update(apology: )' do
    let(:candidate_in_row){ FactoryBot.create(:candidate) }
    let(:comming1){ FactoryBot.create(:candidate_entry_test, entry_test: entry_test) }
    let(:comming2){ FactoryBot.create(:candidate_entry_test, entry_test: entry_test) }

    it 'put candidate on the end of the row' do
      comming1; comming2

      expect(candidate_in_row.position).to eq(1)

      comming1.update(apology: 'Nedam to proste')
      comming1.reload; candidate_in_row.reload

      expect(comming1.arrival).to eq('apology')
      expect(comming1.candidate.state).to eq('for_entry_test')
      expect(candidate_in_row.position).to eq(1)
      expect(comming1.candidate.position).to eq(2)
    end
  end
end
