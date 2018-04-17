class InterviewSchema < AzaharaSchema::ModelSchema

  def self.attribute(model, name, attr_type=nil)
    if name == 'region_court_id'
      RegionCourtIdAttribute.new(model, name)
    else
      super
    end
  end

  def default_outputs
    ['tiles']
  end

  def default_sort
    {'time' => :desc}
  end

  def enabled_filters
    ['time', 'region_court_id']
  end

  def default_columns
    ['time', 'region_court_id']
  end

end
