class EntryTestsController < ApplicationController

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
      if @entry_test.save
        format.html{ redirect_to @entry_test }
      else
        format.html{ render 'new' }
      end
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

  private

    def create_params
      params.require(:entry_test).permit(:time, :place, :capacity)
    end

    def evaluate_params
      params.require(:entry_test).permit(candidate_entry_tests_attributes: [:id, :arrival, :points])
    end

end
