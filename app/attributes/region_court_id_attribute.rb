class RegionCourtIdAttribute < AzaharaSchema::Attribute
  def initialize(model, name)
    super(model, name, 'love')
  end

  def available_values
    EgovUtils::Organization.region_courts.collect{|o| [o.name, o.id] }
  end

  def value(record)
    EgovUtils::Organization.where(id: super).first.try(:name)
  end
end
