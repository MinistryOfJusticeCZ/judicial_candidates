class EntryTest < ApplicationRecord

  has_many :candidate_entry_tests
  has_many :candidates, through: :candidate_entry_tests

  validates :time, presence: true
  validates :time, inclusion: {in: ->(t){ (Time.now+2.months..Time.now+5.years) }}, on: :create
  validates :capacity, numericality: true

  enum place: {kromerizA: 1, kromerizB: 2, kromerizC: 3, praha_micanky: 10, praha_hybernska: 11}

  accepts_nested_attributes_for :candidate_entry_tests

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
      confirm
      candidates.each do |candidate|
        candidate.invite_to!(self)
      end
    end
  end

  def evaluate!(point_params)
    update(point_params)
    evaluate
  end

end
