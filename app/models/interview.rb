class Interview < ApplicationRecord
  # belongs_to :region_court, class_name: 'Organization' #it is love
  belongs_to :address, class_name: 'EgovUtils::Address', optional: true
  has_many :candidate_interviews
  has_many :candidates, through: :candidate_interviews

  accepts_nested_attributes_for :address

  validates :boundary, numericality: true, allow_nil: true
  validates :time, presence: true

  after_create :invite_candidates

  def candidates_for_invite
    Candidate.for_interview(region_court_id, boundary)
  end

  def passed?
    time < Time.now
  end

  def evaluated?
    candidate_interviews.all{|ci| !ci.invited? }
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

end
