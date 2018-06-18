class EntryTestsController < ApplicationController

  layout 'card', except: :index

  load_and_authorize_resource

  def index
    azahara_schema_index
  end

  def show
    @evaluate_params = params.permit(entry_tests: [:id, :arrival, :points])
  end

  def new
  end

  def create
    respond_to do |format|
      if @entry_test.save
        format.html{ redirect_to @entry_test }
      else
        format.html{ render 'new' }
      end
    end
  end

  def edit

  end

  def update
    respond_to do |format|
      if @entry_test.update(update_params)
        @entry_test.candidates.each do |candidate|
          CandidateMailer.entry_test_update(candidate, @entry_test, @entry_test.audits.last).deliver_later
        end
        format.html{ redirect_to @entry_test }
      else
        format.html{ render 'new' }
      end
    end
  end

  def destroy
    @entry_test.destroy
    respond_to do |format|
      @entry_test.candidates.each do |candidate|
        CandidateMailer.entry_test_cancel(candidate, @entry_test.audits.last).deliver_later
      end
      format.html { redirect_to entry_tests_path, notice: t('common_labels.notice_destroyed', model: @entry_test.model_name.human) }
      format.json { head :ok }
    end
  end

  def evaluate
    respond_to do |format|
      if @entry_test.evaluate!(evaluate_params)
        format.html{ redirect_to @entry_test, notice: t('success_evaluation') }
      else
        format.html{ render 'show' }
      end
    end
  end

  def import_results
    require 'csv'
    if params[:csv_results]
      results = CSV.read(params[:csv_results].path, col_sep: ';', skip_blanks: true)
      mail_points = {}
      results[1..-1].each do |row|
        mail_points[row[0].to_s.downcase] = row[1].to_i
      end
      attrs = {}
      @entry_test.candidate_entry_tests.preload(candidate: :user).each do |candidate_entry_test|
        mail = candidate_entry_test.candidate.user.mail
        attrs[candidate_entry_test.id] = {arrival: (mail_points[mail].nil? ? 'absent' : 'arrived'), points: mail_points[mail]}
      end
      redirect_to entry_test_path(@entry_test, entry_tests: attrs)
    else
      flash[:warning] = 'missing file'
      redirect_to @entry_test
    end
  end

  protected
    def require_login?
      super && params[:action] != 'index'
    end

  private

    def create_params
      params.require(:entry_test).permit(:time, :place, :capacity, :additional_info)
    end

    def update_params
      params.require(:entry_test).permit(:time, :place, :additional_info, :audit_comment)
    end

    def evaluate_params
      params.require(:entry_test).permit(candidate_entry_tests_attributes: [:id, :arrival, :points])
    end

end
