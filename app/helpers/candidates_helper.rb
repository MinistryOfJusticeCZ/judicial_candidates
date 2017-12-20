module CandidatesHelper

  def diploma_thumb(candidate)
    if candidate.diploma.ext == 'pdf'
      content_tag('i', '', class: 'fa fa-file-pdf-o fa-3x')
    else
      begin
        image_tag(candidate.diploma.thumb('250x250#').url, alt: Candidate.human_attribute_name('diploma'))
      rescue
        'File not found'
      end
    end
  end

end
