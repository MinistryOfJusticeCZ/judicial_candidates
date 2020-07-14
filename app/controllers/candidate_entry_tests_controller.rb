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
      candidates.each do |candidate|
        CandidateMailer.entry_test_invitation(candidate, @entry_test).deliver_later
      end
    end
    redirect_to @entry_test
  end

  def edit
  end

  def update
    respond_to do |format|
      if @candidate_entry_test.update(update_params)
        invite_alternate if invite_alternate?
        format.html{ redirect_to @candidate_entry_test.candidate, notice: t('notice_excuse_sent') }
      else
        format.html{ render 'edit' }
      end
    end
  end

  private

    def invite_alternate?
      !@candidate_entry_test.entry_test.passed? && @candidate_entry_test.saved_change_to_arrival? &&
        [nil, 'invited', 'arrived'].include?(@candidate_entry_test.arrival_before_last_save) &&
        (@candidate_entry_test.apology? || @candidate_entry_test.excused?)
    end

    def invite_alternate
      if ( alternate = Candidate.for_specific_entry_test(@entry_test).first )
        alternate.invite_to!(@entry_test)
        CandidateMailer.entry_test_invitation(alternate, @candidate_entry_test.entry_test).deliver_later
      end
    end

    def candidates
      @candidates ||= Candidate.for_specific_entry_test(@entry_test).limit(@entry_test.capacity - @entry_test.candidate_entry_tests.comming.count)
    end

    def update_params
      # WARNING: if more allowed attributes, check candidate role permissions for update
      attrs = %i[apology]
      attrs << :arrival if can?(:invalidate, @candidate_entry_test)
      params.require(:candidate_entry_test).permit(*attrs)
    end

end
