class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_candidate


  def require_login?
    true
  end

  def current_candidate
    @current_candidate ||= Candidate.find_by(user_id: current_user.id) if current_user.logged?
  end
end
