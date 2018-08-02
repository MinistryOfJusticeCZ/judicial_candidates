class CandidateSchema < AzaharaSchema::ModelSchema

  def main_attribute_name
    'user-fullname'
  end

  def default_columns
    cols = ['user-fullname']
    cols << 'user-mail' if EgovUtils::User.current.has_role?('ooj') || EgovUtils::User.current.has_role?('admin')
    cols.concat(['updated_at', 'state'])
    cols
  end

  def default_outputs
    ['grid']
  end

  def enabled_filter_names
    ['state', 'user-fullname']
  end

end
