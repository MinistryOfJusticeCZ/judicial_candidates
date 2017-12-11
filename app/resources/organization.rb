class Organization < EgovUtils::Love

  def self.region_courts
    all(params: {f: {category_abbrev: '=|KS'}, sort: {'0' => {path: 'name'} }})
  end

  def self.district_courts(superior_id=nil)
    f = superior_id ? {superior_id: superior_id} : {}
    all(params: {f: f.merge({category_abbrev: '=|OS'}), sort: {'0' => {path: 'name'} }})
  end

end
