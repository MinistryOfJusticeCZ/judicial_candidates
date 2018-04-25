class Interview < ApplicationRecord
  # belongs_to :region_court, class_name: 'Organization' #it is love
  belongs_to :address, class_name: 'EgovUtils::Address', optional: true
  has_many :candidate_interviews, dependent: :destroy
  has_many :excused_candidate_interviews, ->{ excuses }, class_name: 'CandidateInterview'
  has_many :candidates, through: :candidate_interviews

  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :candidate_interviews

  validates :boundary, numericality: true, allow_nil: true
  validates :time, presence: true
  validates :time, inclusion: {in: ->(t){ (Time.now+14.days..Time.now+5.years) }}, on: :create
  validates :time, inclusion: {in: ->(t){ (Time.now..Time.now+5.years) }}, on: :update, if: :time_changed?

  acts_as_paranoid
  audited

  scope :in_future, ->{
    where( arel_table[:time].gteq(Time.now) )
  }


  after_create :invite_candidates
  after_save   :invite_compensatory, if: :saved_change_to_compensatory?

  def candidates_for_invite
    Candidate.for_interview(region_court_id, boundary)
  end

  def not_invited_candidates
    Candidate.for_interview(region_court_id, nil).where.not(id: candidate_interviews.pluck(:candidate_id))
  end

  def passed?
    time < Time.now &&
      ( compensatory.nil? || compensatory < Time.now ) &&
      ( !compensatory.nil? || excused_candidate_interviews.count == 0 )
  end

  def evaluated?
    @evaluated ||= candidate_interviews.all?{|ci| !ci.invited? && !ci.compensatory? }
  end

  def evaluate!(state_params)
    state_params = state_params.dup
    attributes = state_params['candidate_interviews_attributes']
    #fill missing candidates and mark them as not comming to the test
    candidate_interviews.where.not(id: attributes.keys).pluck(:id).each do |missing_id|
      attributes[missing_id] ||= {'id' => missing_id}
      attributes[missing_id]['state'] ||= 'absent'
    end
    update(state_params)
  end

  private
    def invite_candidates
      transaction do
        candidates_for_invite.each do |candidate|
          candidate.interviews << self
          candidate.save
        end
      end
    end

    def invite_compensatory
      transaction do
        candidate_interviews.where(state: 'invited').where.not(apology: nil).each do |candidate_interview|
          candidate_interview.invite_compensatory
        end
      end
    end

end
