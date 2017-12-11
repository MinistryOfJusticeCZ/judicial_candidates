class CandidateMailer < ApplicationMailer

  def approved_notification(candidate)
    @candidate = candidate
    mail(to: candidate.user.mail, subject: t(:app_name))
  end

end
