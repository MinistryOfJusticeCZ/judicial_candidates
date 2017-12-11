class CandidateEntryTestSchema < AzaharaSchema::ModelSchema

  def main_attribute_name
    'entry_test-time'
  end

  def default_columns
    ['entry_test-time', 'entry_test-place', 'entry_test-capacity', 'arrival']
  end

  def default_sort
    {'time' => :desc}
  end

  def default_outputs
    ['tiles']
  end
end
