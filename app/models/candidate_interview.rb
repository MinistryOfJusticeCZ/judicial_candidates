class CandidateInterview < ApplicationRecord

  belongs_to :candidate
  belongs_to :interview

  scope :comming, ->{
    where( arel_table[:state].in(['invited', 'successful', 'failed']) )
  }

  scope :excuses, ->{
    where( arel_table[:state].eq('excused').or(arel_table[:state].eq('invited').and(arel_table[:apology].not_eq(nil))) )
  }

  state_machine :initial => :invited do
    after_transition any => :failed do |entity, transition|
      entity.candidate.failed_interview
    end

    after_transition any => :absent do |entity, transition|
      entity.candidate.absent_interview
    end

    event :excused do
      transition invited: :excused
    end
    event :invite_compensatory do
      transition excused: :compensatory
    end
    event :succeeded do
      transition [:invited, :compensatory] => :successful
    end
    event :failed do
      transition [:invited, :compensatory] => :failed
    end
    event :absence do
      transition [:invited, :compensatory] => :absent
    end
  end

end
