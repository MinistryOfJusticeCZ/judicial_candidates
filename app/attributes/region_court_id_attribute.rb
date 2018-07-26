class RegionCourtIdAttribute < AzaharaSchema::Attribute
  def initialize(model, name)
    super(model, name, 'love')
  end

  def available_values
    EgovUtils::Organization.region_courts.collect{|o| [o.name, o.id] }
  end

end
