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

  def entry_test_update(candidate, entry_test, audit)
    @candidate, @entry_test, @audit = candidate, entry_test, audit
    mail(to: candidate.user.mail, subject: t(:app_name) + ' – oznámení o změně termínu konání vstupního testu')
  end

  def entry_test_cancel(candidate, audit)
    @candidate, @audit = candidate, audit
    mail(to: candidate.user.mail, subject: t(:app_name) + ' – oznámení o zrušení termínu konání vstupního testu')
  end

  #TODO
  def interview_invitation(candidate, interview)
    @candidate, @interview = candidate, interview
    mail(to: candidate.user.mail, subject: t(:app_name) + ' – pozvánka na Výběrové řízení')
  end

  def interview_not_invited(candidate, interview)
    @candidate, @interview = candidate, interview
    mail(to: candidate.user.mail, subject: t(:app_name) + ' – konané Výběrové řízení')
  end

  def interview_compensatory_invitation(candidate, interview)
    @candidate, @interview = candidate, interview
    mail(to: candidate.user.mail, subject: t(:app_name) + ' – pozvánka na náhradní Výběrové řízení')
  end

  def interview_evaluation(candidate_interview)
    @candidate_interview = candidate_interview
    @candidate = candidate_interview.candidate
    mail(to: @candidate.user.mail, subject: t(:app_name) + ' – výsledek pohovoru')
  end

end
