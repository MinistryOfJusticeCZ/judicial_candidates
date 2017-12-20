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

end
