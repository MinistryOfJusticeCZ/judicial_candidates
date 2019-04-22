require 'rails_helper'

RSpec.describe CandidateEntryTestsController, type: :controller do
  let(:capacity) { 3 }
  let(:entry_test) { FactoryBot.create(:entry_test, state: 'unconfirmed', capacity: capacity) }

  context 'integration', slow: true do
    let(:capacity) { 5 }
    describe '#create', logged: :academy do
      let(:candidates) { FactoryBot.create_list(:candidate, capacity) }

      it 'invites all the candidates' do
        candidates;
        expect{
          post :create, params: { entry_test_id: entry_test.id }
        }.to change{ Candidate.where(state: 'invited_to_test').count }.from(0).to(capacity)
      end
    end
  end

  describe '#update' do
    context 'apology', logged: true do
      let(:entry_test) { FactoryBot.create(:entry_test, :listed, capacity: 2) }
      let!(:current_candidate){ FactoryBot.create(:candidate, :invited_to_test, entry_test: entry_test, user: signed_user) }
      let!(:invited_candidate){ FactoryBot.create(:candidate, :invited_to_test, entry_test: entry_test) }
      let!(:uninvited_candidate){ FactoryBot.create(:candidate) }

      it 'invites alternate' do
        expect( controller ).to receive(:invite_alternate).and_call_original
        expect( uninvited_candidate.state ).to eq('for_entry_test')
        patch :update, params: { entry_test_id: entry_test.id, id: current_candidate.candidate_entry_tests.first.id, candidate_entry_test: {apology: 'nemohu prijiti :('} }
        expect( uninvited_candidate.reload.state ).to eq('invited_to_test')
      end
    end
  end
end
