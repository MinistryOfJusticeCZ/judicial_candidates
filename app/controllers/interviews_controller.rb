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
        format.html { redirect_to @interview, notice: t('common_labels.notice_saved', model: @interview.model_name.human) }
        format.json { render json: @interview, status: :created }
      else
        format.html { render 'new',  layout: !request.xhr? }
        format.json { render json: { errors: @interview.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  private
    def create_params
      params.require(:interview).permit(:time, :region_court_id, :boundary, {address_attributes: [:street, :house_number, :orientation_number, :city, :region, :district, :postcode]})
    end

end
