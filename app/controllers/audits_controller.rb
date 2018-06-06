class AuditsController < ApplicationController

  def index
    @audits = Audited::Audit.order(created_at: :desc).limit(150)
  end

end
