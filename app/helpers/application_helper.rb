module ApplicationHelper

  def google_analytics_code
    'UA-61215343-17'
  end

  def additional_tile_actions_for(entity)
    case entity
    when CandidateEntryTest
      if can?(:edit, entity) && can?(:invalidate, entity) && entity.arrival == 'arrived' && entity.can_be_invalidated?
        button_to(
          t('label_invalidate'),
          [entity.entry_test, entity],
          method: :patch,
          class: 'btn btn-warning',
          data: { confirm: t('text_invalidate_test_confirm') },
          params: { candidate_entry_test: { arrival: 'invalidated' } }
        )
      end
    else
      nil
    end
  end

end
