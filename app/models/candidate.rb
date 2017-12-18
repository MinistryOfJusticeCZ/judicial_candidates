class Candidate < ApplicationRecord
  belongs_to :user, class_name: 'EgovUtils::User'
  has_many :candidate_entry_tests
  has_many :entry_tests, through: :candidate_entry_tests
  has_many :candidate_interviews
  has_many :interviews, through: :candidate_interviews

  enum university: {cuni: 1, muni: 2, zcu: 3, upol: 4}

  accepts_nested_attributes_for :user

  validates :birth_date, presence: true
  validates :graduation_year, inclusion: 1900..9999, numericality: { only_integer: true, less_than_or_equal_to: :current_year }
  validates :user_id, uniqueness: true
  validates :phone, phone: true
  validates :agreed_limitations, presence: true

  dragonfly_accessor :diploma

  scope :for_entry_test, ->{ where(state: 'for_entry_test').order(updated_at: :asc) }
  scope :for_interview, ->(region_court_id, boundary=nil){
    res = where(state: 'waiting', organizations: region_court_id)
    res = res.joins(:candidate_entry_tests).where(CandidateEntryTest.arel_table[:points].gteq(boundary)) if boundary
    res.order(updated_at: :asc)
  }

  enum state: { incomplete: 0, validation: 1, rejected: 3, for_entry_test: 10, waiting: 15 }, _suffix: true

  state_machine :initial => :incomplete do
    # before_transition :parked => any - :parked, :do => :put_on_seatbelt
    # after_transition any => :parked do |vehicle, transition|
    #   vehicle.seatbelt = 'off'
    # end

    event :finalize do
      transition incomplete: :validation
    end

    event :approve do
      transition validation: :for_entry_test
    end

    event :disapprove do
      transition validation: :incomplete
    end

    event :reject do
      transition validation: :rejected
    end

    event :succeded_entry_test do
      transition for_entry_test: :waiting
    end

    state any - :incomplete do
      validates :university, presence: true
    end
  end

  def organizations=(values)
    values = values.select{|v| v.present?} if values.is_a?(Array)
    super(values)
  end

  def suborganizations=(values)
    values = values.select{|v| v.present?} if values.is_a?(Array)
    super(values)
  end

  def invite_to!(entry_test)
    candidate_entry_tests.create(entry_test: entry_test)
  end

  private
    def current_year
      Date.today.year
    end

end
