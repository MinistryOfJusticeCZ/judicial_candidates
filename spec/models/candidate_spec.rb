require 'rails_helper'

RSpec.describe Candidate, type: :model do

  describe '::for_interview scope' do
    let(:entry_test){ FactoryBot.create(:entry_test) }
    let!(:candidate_for_entry_test) { FactoryBot.create(:candidate, state: 'for_entry_test') }
    let!(:candidate_interview_diff_org) { FactoryBot.create(:candidate, :for_interview, entry_test: entry_test, organizations: ['205000']) }
    let!(:candidate_for_interview) { FactoryBot.create(:candidate, :for_interview, entry_test: entry_test, organizations: ['204000'], test_points: 60) }
    let!(:candidate_for_interview_more_orgs) { FactoryBot.create(:candidate, :for_interview, entry_test: entry_test, organizations: ['204000', '205000'], test_points: 70) }

    it 'select candidate for specified organization' do
      expect(Candidate.for_interview('204000').pluck(:id)).to contain_exactly(candidate_for_interview.id, candidate_for_interview_more_orgs.id)
    end

    it 'select candidate above specified boundary' do
      expect(Candidate.for_interview('204000', 70).pluck(:id)).to contain_exactly(candidate_for_interview_more_orgs.id)
    end
  end
end
