class CandidateEntryTest < ApplicationRecord
  belongs_to :candidate
  belongs_to :entry_test

  enum arrival: {arrived: 1, absent: 2, apology: 3, excused: 4}

  scope :comming, ->{ where(arel_table[:arrival].eq(nil).or(arel_table[:arrival].lteq(2))) }
  scope :apologized, ->{ where(arrival: [:apology, :excused]) }

  after_save :set_candidate_state, if: :points?

  def apology=(text)
    super
    self.arrival = 'apology'
  end

  def arrival
    val = super
    case val
    when 'arrived'
      entry_test.passed? ? val : 'invited'
    else
      val || 'invited'
    end
  end

  private
    def set_candidate_state
      candidate.succeded_entry_test
    end

end
