class CandidateSchema < AzaharaSchema::ModelSchema

  def main_attribute_name
    'user-fullname'
  end

  def default_columns
    ['user-fullname', 'user-mail', 'updated_at', 'state']
  end

  def default_outputs
    ['grid']
  end

  def enabled_filter_names
    ['state']
  end

end
