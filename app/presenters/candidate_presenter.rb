class CandidatePresenter < AzaharaSchema::Presenter

  def attribute_human_value(attribute, entity, **options)
    case attribute.name
    when 'state'
      val = super
      val.concat(" (#{t('label_candidate_order', order: entity.position)})") if entity.for_entry_test?
      val
    else
      super
    end
  end

end
