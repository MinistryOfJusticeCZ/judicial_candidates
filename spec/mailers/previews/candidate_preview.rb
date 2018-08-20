# Preview all emails at http://localhost:3000/rails/mailers/candidate
class CandidatePreview < ActionMailer::Preview
  def interview_invitation
    CandidateMailer.interview_invitation(Candidate.new(user: EgovUtils::User.current), Interview.first)
  end
end
