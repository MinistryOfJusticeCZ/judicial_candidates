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
        if !@candidate_interview.apology.blank? && @candidate_interview.apology_previously_changed?
          JudgeMailer.interview_apology_received(@candidate_interview).deliver_later
          flash[:notice] = t('notice_excuse_sent')
        end
        if @candidate_interview.assigned_hour_previously_changed?
          CandidateMailer.interview_hour_assigned(@candidate_interview).deliver_later
          flash[:notice] = t('notice_interview_hour_assigned')
        end
        format.html{ redirect_to @interview }
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
      if current_candidate.id == @candidate_interview.candidate_id
        params.require(:candidate_interview).permit(:apology)
      elsif current_user.has_role?('judge')
        params.require(:candidate_interview).permit(:assigned_hour)
      end
    end

end
