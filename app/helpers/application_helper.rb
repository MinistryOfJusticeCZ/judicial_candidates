module ApplicationHelper

  def google_analytics_code
    'UA-61215343-17'
  end

  def additional_tile_actions_for(entity)
    case entity
    when CandidateEntryTest
      res = ''.html_safe
      if can?(:edit, entity)
        if can?(:invalidate, entity) && entity.arrival == 'arrived' && entity.can_be_invalidated?
          res << button_to(
            t('label_invalidate'),
            [entity.entry_test, entity],
            method: :patch,
            class: 'btn btn-warning',
            data: { confirm: t('text_invalidate_test_confirm') },
            params: { candidate_entry_test: { arrival: 'invalidated' } }
          )
        elsif entity.absent? && can?(:excuse, entity)
          res << button_to(
            t('label_excuse'),
            [entity.entry_test, entity],
            method: :patch,
            class: 'btn btn-warning',
            data: { confirm: t('text_excuse_test_confirm') },
            params: { candidate_entry_test: { arrival: 'excused', apology: 'Ext-post spravcem' } }
          )
        end
      end
      res
    else
      nil
    end
  end

end
