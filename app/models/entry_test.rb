class EntryTest < ApplicationRecord

  has_many :candidate_entry_tests, dependent: :destroy
  has_many :candidates, through: :candidate_entry_tests

  validates :time, presence: true
  validates :time, inclusion: {in: ->(t){ (Time.now+2.months..Time.now+5.years) }}, on: :create
  validates :capacity, numericality: true

  enum place: {kromerizA: 1, kromerizB: 2, kromerizC: 3, praha_micanky: 10, praha_hybernska: 11, olomouc_ks_ostrava: 16}

  accepts_nested_attributes_for :candidate_entry_tests

  acts_as_paranoid
  audited

  scope :in_future, ->{
    where( arel_table[:time].gteq(Time.now) )
  }

  state_machine :initial => :unconfirmed do
    # before_transition :parked => any - :parked, :do => :put_on_seatbelt
    # after_transition any => :parked do |vehicle, transition|
    #   vehicle.seatbelt = 'off'
    # end

    event :confirm do
      transition unconfirmed: :listed
    end

    event :evaluate do
      transition [:listed, :passed] => :evaluated
    end
  end

  def passed?
    time < Time.now
  end

  def confirm_and_invite!(candidates)
    transaction do
      candidates.each do |candidate|
        candidate.invite_to!(self)
      end
      confirm unless listed?
    end
  end

  def evaluate!(point_params)
    point_params = point_params.dup
    attributes = point_params['candidate_entry_tests_attributes']
    #fill missing candidates and mark them as not comming to the test
    candidate_entry_tests.comming.where.not(id: attributes.keys).pluck(:id).each do |missing_id|
      attributes[missing_id] ||= {'id' => missing_id}
      attributes[missing_id]['arrival'] ||= 'absent'
    end
    update(point_params.merge(state: 'evaluated'))
    # update apologized
    candidate_entry_tests.apologized.each{|ct| ct.update(updated_at: Time.now) }
  end

end
