class CandidatesController < ApplicationController
  layout 'card', only: [:new, :edit, :show]

  before_action :translate_me_to_id

  load_and_authorize_resource

  def index
    azahara_schema_index
  end

  def show
  end

  def new
    raise CanCan::AccessDenied.new(current_ability.unauthorized_message(:create, Candidate), :create, Candidate) if current_candidate
    @candidate.user = current_user
  end

  def create
    @candidate.user_id = current_user.id
    @candidate.state = 'incomplete'
    respond_to do |format|
      if @candidate.save
        format.html{ redirect_to @candidate }
      else
        format.html{ render 'edit' }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @candidate.update(update_params)
        format.html{ redirect_to @candidate }
      else
        format.html{ render 'new' }
      end
    end
  end

  def finalize
    authorize!(:manage, @candidate)
    @candidate.finalize
    redirect_to @candidate
  end

  def approve
    authorize!(:approve, @candidate)
    @candidate.approve
    CandidateMailer.approved_notification(@candidate).deliver_later
    redirect_to candidates_path
  end

  def disapprove
    authorize!(:disapprove, @candidate)
    @candidate.audit_comment = params[:candidate][:audit_comment]
    @candidate.disapprove
    CandidateMailer.incomplete_profile(@candidate, @candidate.audits.last).deliver_later
    redirect_to candidates_path
  end


  private

    def translate_me_to_id
      if params[:id] == 'me'
        redirect_to new_candidate_path unless current_candidate
        params[:id] = current_candidate.try(:id)
      end
    end

    def create_params
      params.require(:candidate).permit( :birth_date, :phone, :university, :graduation_year, :higher_title, {organizations: [], suborganizations: []}, :shorter_invitation, :agreed_limitations, :diploma)
    end

    def update_params
      create_params
    end

end
