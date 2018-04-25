require 'rails_helper'

RSpec.describe CandidateEntryTestsController, type: :controller do

  describe '#update' do

    context 'apology', logged: true do
      let!(:current_candidate){ FactoryBot.create(:candidate, user: signed_user) }
      let(:entry_test){ FactoryBot.create(:entry_test, state: 'unconfirmed' ) }
      let!(:invited_candidate){ FactoryBot.create(:candidate) }
      let!(:uninvited_candidate){ FactoryBot.create(:candidate) }

      before(:each) do
        entry_test.confirm_and_invite!([current_candidate, invited_candidate])
      end

      it 'invites alternate' do
        expect( controller ).to receive(:invite_alternate).and_call_original
        expect( uninvited_candidate.state ).to eq('for_entry_test')
        post :update, params: { entry_test_id: entry_test.id, id: current_candidate.candidate_entry_tests.first.id, candidate_entry_test: {apology: 'nemohu prijiti :('} }
        expect( uninvited_candidate.reload.state ).to eq('invited_to_test')
      end

    end


  end

end
