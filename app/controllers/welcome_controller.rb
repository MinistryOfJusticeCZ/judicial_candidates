class WelcomeController < ApplicationController

  # layout 'card', only: 'about'

  skip_before_action :require_login, only: [:about]

  def index
    if current_user.has_role?('candidate')
      if current_candidate && !current_candidate.incomplete?
        @entry_tests = CandidateEntryTestSchema.new
        @entry_tests.visibility_scope!(current_ability)
        @interviews = CandidateInterviewSchema.new
        @interviews.visibility_scope!(current_ability)
        render('index_candidate')
      else
        redirect_to( current_candidate || new_candidate_path )
      end
    elsif current_user.has_role?('ooj')
      redirect_to(candidates_path)
    elsif current_user.has_role?('academy')
      redirect_to(entry_tests_path)
    else
      redirect_to(interviews_path)
    end
  end

  def about

  end

end
