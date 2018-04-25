require 'rails_helper'

RSpec.describe EntryTest, type: :model do

  let(:test_time) { Time.now + 2.months }
  let(:entry_test){ FactoryBot.create(:entry_test, time: test_time, capacity: 2) }

  describe 'confirm_and_invite!' do
    def create_candidate_double
      candidate = instance_double('Candidate')
      expect(candidate).to receive('invite_to!').with(entry_test)
      candidate
    end

    let(:candidates) { (1..3).to_a.collect{ create_candidate_double } }

    it 'invites given candidates and confirm the entry_test' do
      entry_test.confirm_and_invite!(candidates)
      expect(entry_test).to be_listed
    end
  end

  # TODO pretty time ineficient - it tests too much of things
  describe '#evaluate!' do
    let(:test_time) { Time.now - 1.day }
    let(:candidate_in_row){ FactoryBot.create(:candidate) }
    let(:apologized){ FactoryBot.create(:candidate_entry_test, entry_test: entry_test, arrival: 'apology') }
    let(:excused){ FactoryBot.create(:candidate_entry_test, entry_test: entry_test, arrival: 'excused') }
    let(:comming1){ FactoryBot.create(:candidate_entry_test, entry_test: entry_test) }
    let(:comming2){ FactoryBot.create(:candidate_entry_test, entry_test: entry_test) }

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
