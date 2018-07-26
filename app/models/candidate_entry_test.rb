class CandidateEntryTest < ApplicationRecord
  belongs_to :candidate
  belongs_to :entry_test

  validates :candidate_id, uniqueness: { scope: :entry_test_id }

  enum arrival: {arrived: 0, invited: 1, absent: 2, apology: 3, excused: 4}

  scope :comming, ->{ where(arel_table[:arrival].eq(nil).or(arel_table[:arrival].lteq(2))) }
  scope :apologized, ->{ where(arrival: [:apology, :excused]) }
  scope :valid, ->{ all }

  audited

  after_save :set_candidate_state

  def apology=(text)
    return unless can_appologize?
    super
    self.arrival = 'apology' if text
  end

  def can_appologize?
    Time.now < (entry_test.time.end_of_day + 3.days)
  end

  def test_passed?
    entry_test.passed?
  end

  def test_evaluated?
    entry_test.evaluated?
  end

  def arrival
    val = super
    case val
    when 'arrived'
      test_passed? ? val : 'invited'
    else
      val || 'invited'
    end
  end

  private

    def set_candidate_state
      return unless candidate.invited_to_test?
      if absent?
        candidate.absent_on_test
      elsif apology? || excused?
        candidate.excuse_on_entry_test!(entry_test)
      elsif test_evaluated?
        candidate.succeded_entry_test
      end
    end

end
