class CandidateInterviewsController < ApplicationController

  load_and_authorize_resource :entry_test
  load_and_authorize_resource through: :entry_test, only: [:index]

  def index
    azahara_schema_index
  end

end
