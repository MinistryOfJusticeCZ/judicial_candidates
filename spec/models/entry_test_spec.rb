require 'rails_helper'

RSpec.describe EntryTest, type: :model do

  let(:entry_test){ FactoryBot.create(:entry_test) }

  describe '#evaluate!' do
    let(:candidate_in_row){ FactoryBot.create(:candidate) }
    let(:apologized){ FactoryBot.create(:candidate_entry_test, entry_test: entry_test, arrival: 'apology') }
    let(:excused){ FactoryBot.create(:candidate_entry_test, entry_test: entry_test, arrival: 'excused') }
    let(:comming1){ FactoryBot.create(:candidate_entry_test, entry_test: entry_test) }
    let(:comming2){ FactoryBot.create(:candidate_entry_test, entry_test: entry_test) }

    it 'push apologized candidate to end of waiting row' do
      # first validate the creation of the records - factories itself
      expect(apologized.candidate.state).to eq('invited_to_test')
      expect(excused.candidate.state).to eq('invited_to_test')
      expect(apologized.candidate.position).to eq(1)
      expect(excused.candidate.position).to eq(2)
      expect(candidate_in_row.position).to eq(1)

      #now the real test comes
      entry_test.evaluate!({'candidate_entry_tests_attributes' => {}})

      apologized.reload; excused.reload

      expect(apologized.candidate.state).to eq('for_entry_test')
      expect(excused.candidate.state).to eq('for_entry_test')

      expect(candidate_in_row.position).to eq(1)
      expect(apologized.candidate.position).to eq(2)
      expect(excused.candidate.position).to eq(3)
    end

    it 'blocks unapologized user' do
      expect(comming1.candidate.state).to eq('invited_to_test')
      expect(comming2.candidate.state).to eq('invited_to_test')

      entry_test.evaluate!({'candidate_entry_tests_attributes' => {comming2.id => {'id' => comming2.id, 'points' => '35'}}})

      comming1.reload; comming2.reload

      expect(comming1.candidate.state).to eq('blocked')
      expect(comming2.candidate.state).to eq('waiting')
      expect(comming2.points).to eq(35)
    end
  end

end
