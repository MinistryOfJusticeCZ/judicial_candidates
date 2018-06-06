class AuditsController < ApplicationController

  def index
    @audits = Audited::Audit.order(created_at: :desc).limit(150)
    if params[:entry_test_id]
      @entry_test = EntryTest.find(params[:entry_test_id])
      at = Audited::Audit.arel_table
      @audits = @audits.where(
          (at[:auditable_type].eq('EntryTest').and(at[:auditable_id].eq(@entry_test.id)))
            .or( at[:auditable_type].eq('CandidateEntryTest').and(at[:auditable_id].in(@entry_test.candidate_entry_tests.pluck(:id))) )
            .or( at[:auditable_type].eq('Candidate').and(at[:auditable_id].in(@entry_test.candidate_entry_tests.pluck(:candidate_id))) )
        )
    end
  end

end
