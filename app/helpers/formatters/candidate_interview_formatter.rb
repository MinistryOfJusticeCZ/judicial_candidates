module Formatters
  class CandidateInterviewFormatter < AzaharaSchema::AttributeFormatter

    def new_path(options)
      nil
    end

    def show_path(entity, **options)
      template.polymorphic_path(entity.interview, options)
    end

  end
end
