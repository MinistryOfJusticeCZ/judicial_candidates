class CandidateInterviewsController < ApplicationController

  load_and_authorize_resource :interview
  load_and_authorize_resource through: :interview

  def index
    azahara_schema_index
  end

  def edit
  end

  def update
    respond_to do |format|
      if @candidate_interview.update(update_params)
        JudgeMailer.interview_apology_received(@candidate_interview).deliver_later unless @candidate_interview.apology.blank?
        format.html{ redirect_to @interview, notice: t('notice_excuse_sent') }
      else
        format.html{ render 'edit' }
      end
    end
  end

  def reject_apology
    @candidate_interview.audit_comment = params[:candidate_interview][:audit_comment]
    @candidate_interview.absence
    CandidateMailer.interview_apology_rejected(@candidate_interview).deliver_later
    respond_to do |format|
      format.html{ redirect_to @interview, notice: t('notice_apology_refused') }
    end
  end

  private

    def update_params
      params.require(:candidate_interview).permit(:apology)
    end

end
