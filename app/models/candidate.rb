class Candidate < ApplicationRecord
  belongs_to :user, class_name: 'EgovUtils::User'
  has_many :candidate_entry_tests
  has_many :entry_tests, through: :candidate_entry_tests
  has_many :candidate_interviews
  has_many :interviews, through: :candidate_interviews

  enum university: {cuni: 1, muni: 2, zcu: 3, upol: 4}

  accepts_nested_attributes_for :user

  dragonfly_accessor :diploma

  acts_as_list scope: [:state, deleted_at: nil]
  acts_as_paranoid
  audited


  validates :birth_date, presence: true, birthday: true
  validates :graduation_year, inclusion: 1900..9999, numericality: { only_integer: true, less_than_or_equal_to: :current_year }
  validates :user_id, uniqueness: true
  validates :phone, phone: true
  validates :organizations, presence: true
  validates :agreed_limitations, presence: true

  validates :diploma, presence: true, unless: :incomplete?
  validates_property :format, of: :diploma,
                              in: ['jpeg', 'png', 'pdf'],
                              if: :diploma_changed?,
                              message: ->(prop, entity){I18n.t('diploma_format', scope: 'activerecord.errors.models.candidate', available_formats: 'jpeg, png, pdf') }
  validates_size_of :diploma, maximum: 5.megabytes, if: :diploma_changed?

  scope :for_entry_test, ->{ where(state: 'for_entry_test').order(:position) }
  scope :for_interview, ->(region_court_id, boundary=nil){
    res = where(state: 'waiting').where("'#{region_court_id}' = ANY (#{connection.quote_column_name('organizations')})")
    res = res.joins(:candidate_entry_tests).where(CandidateEntryTest.arel_table[:points].gteq(boundary)) if boundary
    res.order(:position)
  }

  enum state: { incomplete: 0, validation: 1, rejected: 3, blocked: 4, for_entry_test: 10, invited_to_test: 11, waiting: 15 }, _suffix: true

  state_machine do # :initial => :incomplete do - initial is done by default column value
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

    event :invite_to_test do
      transition for_entry_test: :invited_to_test
    end

    event :absent_on_test do
      transition invited_to_test: :blocked
    end

    event :excused_on_entry_test do
      transition invited_to_test: :for_entry_test
    end

    event :succeded_entry_test do
      transition invited_to_test: :waiting
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
    candidate_entry_tests.create(entry_test: entry_test) && invite_to_test
  end

  private

    def current_year
      Date.today.year
    end

end
