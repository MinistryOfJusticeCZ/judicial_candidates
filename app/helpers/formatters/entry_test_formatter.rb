module Formatters
  class EntryTestFormatter < BaseIconFormatter

    def icon_class_for_attribute(attribute)
      case attribute.name
      when 'capacity'
        'fa fa-user-o'
      when 'place'
        'fa fa-map-marker'
      else
        'fa'
      end
    end

    def format_value_html(attribute, unformated_value, **options)
      case attribute.name
      when 'capacity'
        val = super
        val.to_s + ' ' + t('label_attendees', count: val)
      else
        super
      end
    end

  end
end
