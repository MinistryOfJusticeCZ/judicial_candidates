class CandidateInterviewSchema < AzaharaSchema::ModelSchema

  def main_attribute_name
    'interview-time'
  end

  def default_columns
    ['interview-time', 'interview-region_court_id', 'state']
  end

  def default_sort
    {'interview-time' => :desc}
  end

  def default_outputs
    ['tiles']
  end

end
