class CandidateMailer < ApplicationMailer

  def incomplete_profile(candidate, audit)
    @candidate = candidate
    @audit = audit
    mail(to: candidate.user.mail, subject: t(:app_name) + ' - výzva k doplnění údajů')
  end

  def deleted_profile(candidate, audit)
    @candidate = candidate
    @audit = audit
    mail(to: candidate.user.mail, subject: t(:app_name) + ' - smazaný účet')
  end

  def approved_notification(candidate)
    @candidate = candidate
    mail(to: candidate.user.mail, subject: t(:app_name))
  end

  def entry_test_invitation(candidate, entry_test)
    @candidate = candidate
    @entry_test = entry_test
    mail(to: candidate.user.mail, subject: t(:app_name) + ' – pozvánka na vstupní test')
  end

  def interview_invitation(candidate, interview)
    @candidate, @interview = candidate, interview
    mail(to: candidate.user.mail, subject: t(:app_name) + ' – pozvánka na Výběrové řízení')
  end

end
