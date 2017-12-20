class InterviewSchema < AzaharaSchema::ModelSchema

  def default_outputs
    ['tiles']
  end

  def default_sort
    {'time' => :desc}
  end

  def enabled_filters
    ['time', 'region_court_id']
  end

end
