class CandidateMailer < ApplicationMailer

  def interview_apology_received(candidate_interview)
    @candidate_interview = candidate_interview
    @candidate, @interview = candidate_interview.candidate, candidate_interview.interview
    created_by = @interview.audits.first.user
    mail(to: created_by.mail, subject: t(:app_name) + ' – oznámení o přijetí omluvy uchazeče')
  end
end
