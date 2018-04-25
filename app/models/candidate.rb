class Candidate < ApplicationRecord
  belongs_to :user, class_name: 'EgovUtils::User'
  has_many :candidate_entry_tests, dependent: :destroy
  has_many :entry_tests, through: :candidate_entry_tests
  has_many :candidate_interviews, dependent: :destroy
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
    require 'arel/azahara_postgres_exts'
    res = where(state: 'waiting').where(arel_table[:organizations].contains([region_court_id]))
    res = res.joins(:candidate_entry_tests).where(CandidateEntryTest.arel_table[:points].gteq(boundary)) unless boundary.blank?
    res.order(:position)
  }
  scope :alternate_for_entry_test, ->(entry_test){
    if (entry_test.time >= Time.now + 30.days)
      for_entry_test
    elsif (entry_test.time >= Time.now + 7.days)
      for_entry_test.where(shorter_invitation: true)
    else
      where('1=0')
    end
  }

  enum state: { incomplete: 0, validation: 1, rejected: 3, blocked: 4, for_entry_test: 10, invited_to_test: 11, waiting: 15, invited_to_interview: 16 }, _suffix: true

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

    event :absent_second_interview do
      transition waiting: :for_entry_test
    end

    # event :invite_to_interview do
    #   transition waiting: :invited_to_interview
    # end

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
    candidate_entry_tests.create(entry_test: entry_test, arrival: 'arrived') && invite_to_test
  end

  def absent_interview!(interview)
    absent_interviews = candidate_interviews.valid.where(state: 'absent').where.not(interview_id: interview.id)
    if absent_interviews.count >= 1
      update(state: 'for_entry_test', position: nil)
    end
  end

  def excuse_on_entry_test!(entry_test)
    update(state: 'for_entry_test', position: nil)
  end

  def failed_interview!(interview)
    # TODO: nothing?
  end

  private

    def current_year
      Date.today.year
    end

end
