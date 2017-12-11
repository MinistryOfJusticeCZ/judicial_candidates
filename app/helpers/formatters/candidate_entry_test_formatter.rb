module Formatters
  class CandidateEntryTestFormatter < BaseIconFormatter

    def new_path(options)
      nil
    end

    def show_path(entity, **options)
      template.polymorphic_path(entity.entry_test, options)
    end

    def icon_class_for_attribute(attribute)
      case attribute.name
      when 'arrival'
        'fa fa-graduation-cap'
      else
        super
      end
    end

  end
end
