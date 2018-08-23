# Preview all emails at http://localhost:3000/rails/mailers/candidate
class CandidatePreview < ActionMailer::Preview
  def interview_invitation
    CandidateMailer.interview_invitation(Candidate.new(user: EgovUtils::User.current), Interview.first)
  end

  def interview_hour_assigned
    ci = CandidateInterview.first
    ci.assigned_hour = Time.now.change(hour: 13, minute: 0)
    CandidateMailer.interview_hour_assigned(ci)
  end

end
