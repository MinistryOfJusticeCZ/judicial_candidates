class CandidateMailer < ApplicationMailer

  def incomplete_profile(candidate, audit)
    @candidate = candidate
    @audit = audit
    mail(to: candidate.user.mail, subject: t(:app_name) + ' výzva k doplnění údajů')
  end

  def approved_notification(candidate)
    @candidate = candidate
    mail(to: candidate.user.mail, subject: t(:app_name))
  end

end
