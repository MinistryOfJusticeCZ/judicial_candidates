class InterviewSchema < AzaharaSchema::ModelSchema

  def default_outputs
    ['tiles']
  end

  def default_sort
    {'time' => :desc}
  end

end
