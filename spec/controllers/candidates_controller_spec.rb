require 'rails_helper'

RSpec.describe CandidatesController, type: :controller do

  describe '#show', logged: true do

    context '(id=me)' do
      subject { get :show, params: { id: "me" } }

      it 'shows new profile if candidate had not filled the profile yet' do
        expect(subject).to redirect_to(new_candidate_path)
      end
    end
  end

  describe '#destroy', logged: :admin do

    let(:entry_test){ FactoryBot.create(:entry_test, state: 'unconfirmed', capacity: 1 ) }
    let!(:invited_candidate){ FactoryBot.create(:candidate) }
    let!(:uninvited_candidate){ FactoryBot.create(:candidate) }

    before(:each) do
      entry_test.confirm_and_invite!([invited_candidate])
    end

    it 'invites alternate for entry_test' do
      expect( controller ).to receive(:invite_alternates).with([entry_test.id]).and_call_original
      expect( uninvited_candidate.state ).to eq('for_entry_test')
      post :destroy, params: { id: invited_candidate.id, candidate: {audit_comment: 'pozadal o vymazani'} }
      expect( uninvited_candidate.reload.state ).to eq('invited_to_test')
    end

  end

end
