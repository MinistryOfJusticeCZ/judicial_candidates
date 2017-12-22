class ContactMessage
  include ActiveModel::Validations
  extend ActiveModel::Naming

  # to_key
  include ActiveModel::Conversion
  attr_accessor :id

  attr_accessor :mail, :name, :message
  attr_reader :errors

  validates :mail, :name, :message, presence: true
  validates :mail, email: true

  def initialize
    @errors = ActiveModel::Errors.new(self)
  end

  def attributes=(attrs)
    self.mail, self.name, self.message = attrs[:mail], attrs[:name], attrs[:message]
  end

  def param_key
    to_key
  end

end
