class EntryTestSchema < AzaharaSchema::ModelSchema

  def enabled_filters
    ['time', 'place', 'state']
  end

  def main_attribute_name
    'time'
  end

  def default_columns
    ['time', 'place', 'capacity']
  end

  def default_sort
    {'time' => :desc}
  end

  def default_outputs
    ['tiles']
  end
end
