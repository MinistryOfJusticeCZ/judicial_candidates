class CandidateEntryTestsController < ApplicationController

  load_and_authorize_resource :entry_test
  load_and_authorize_resource through: :entry_test, only: [:index]
  load_and_authorize_resource only: [:edit, :update]

  def index
    azahara_schema_index
  end

  def create
    authorize!(:create, CandidateEntryTest)
    if !params[:allow_less_candidates] && candidates.count < @entry_test.capacity
      flash[:warning] = t('warning_not_enough_candidates')
    else
      @entry_test.confirm_and_invite!(candidates)
    end
    redirect_to @entry_test
  end

  def edit
  end

  def update
    respond_to do |format|
      if @candidate_entry_test.update(update_params)
        format.html{ redirect_to root_path, notice: t('notice_excuse_sent') }
      else
        format.html{ render 'edit' }
      end
    end
  end

  private
    def candidates
      @candidates ||= Candidate.for_entry_test.limit(@entry_test.capacity)
    end

    def update_params
      params.require(:candidate_entry_test).permit(:apology)
    end

end
