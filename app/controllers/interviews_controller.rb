class InterviewsController < ApplicationController

  layout 'card', except: :index

  load_and_authorize_resource

  def index
    azahara_schema_index
  end

  def show
  end

  def new
  end

  def create
    respond_to do |format|
      if @interview.candidates_for_invite.count <= 0
        format.html { flash[:warning] = t('warning_not_enough_candidates'); render 'new',  layout: !request.xhr? }
        format.json { render json: { errors: [t('warning_not_enough_candidates')] }, status: :unprocessable_entity }
      elsif @interview.save
        @interview.candidates.each do |candidate|
          CandidateMailer.interview_invitation(candidate, @interview).deliver_later
        end
        @interview.not_invited_candidates.each do |candidate|
          CandidateMailer.interview_not_invited(candidate, @interview).deliver_later
        end
        format.html { redirect_to @interview, notice: t('common_labels.notice_saved', model: @interview.model_name.human) }
        format.json { render json: @interview, status: :created }
      else
        format.html { render 'new',  layout: !request.xhr? }
        format.json { render json: { errors: @interview.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @interview.update(update_params)
        if @interview.compensatory?
          @interview.candidate_interviews.where(state: 'compensatory').each do |candidate_interview|
            CandidateMailer.interview_compensatory_invitation(candidate_interview.candidate, @interview).deliver_later
          end
        end
        format.html { redirect_to @interview, notice: t('common_labels.notice_saved', model: @interview.model_name.human) }
        format.json { render json: @interview }
      else
        format.html { redirect_to @interview, warning: @interview.errors.full_messages.join('\n') }
        format.json { render json: { errors: @interview.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    candidates = @interview.candidates.to_a
    @interview.attributes = params.require(:interview).permit(:audit_comment)
    @interview.destroy
    respond_to do |format|
      candidates.each do |candidate|
        CandidateMailer.interview_canceled(candidate, @interview.audits.last).deliver_later
      end
      format.html { redirect_to interviews_path, notice: t('common_labels.notice_destroyed', model: @interview.model_name.human) }
      format.json { head :ok }
    end
  end

  def evaluate
    respond_to do |format|
      if @interview.evaluate!(evaluate_params)
        @interview.candidate_interviews.each do |candidate_interview|
          CandidateMailer.interview_evaluation(candidate_interview).deliver_later
        end
        format.html{ redirect_to @interview, notice: t('success_evaluation') }
      else
        format.html{ render 'show' }
      end
    end
  end

  private
    def create_params
      params.require(:interview).permit(:time, :region_court_id, :boundary, {address_attributes: [:street, :house_number, :orientation_number, :city, :region, :district, :postcode]})
    end

    def update_params
      params.require(:interview).permit(:time, :compensatory)
    end

    def evaluate_params
      params.require(:interview).permit(candidate_interviews_attributes: [:id, :state])
    end

end
