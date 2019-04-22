require 'rails_helper'

RSpec.describe CandidateInterviewsController, type: :controller do
  let(:interview) { FactoryBot.create(:interview, boundary: 10) }
  let(:invited_candidate){ FactoryBot.create(:candidate, :for_interview, test_points: 20) }
  let(:uninvited_candidate){ FactoryBot.create(:candidate, :for_interview, test_points: 5) }

  describe '#update' do
    before(:each) { invited_candidate; interview }

    context 'as a judge', logged: :judge do
      it 'allows to edit assigned_hour' do
        candidate_interview = invited_candidate.candidate_interviews.first
        expect( candidate_interview.assigned_hour ).to eq(nil)
        patch :update, params: { interview_id: interview.id, id: candidate_interview.id, candidate_interview: { assigned_hour: '10:00' } }
        candidate_interview.reload
        expect( candidate_interview.assigned_hour.hour ).to eq(10)
      end
    end
  end
end
