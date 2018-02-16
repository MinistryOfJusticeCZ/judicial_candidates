module CandidatesHelper

  def diploma_thumb(candidate)
    if candidate.diploma.ext == 'pdf'
      content_tag('i', '', class: 'fa fa-file-pdf-o fa-3x')
    else
      image_tag(candidate.diploma.thumb('250x250#').url, alt: Candidate.human_attribute_name('diploma'))
    end
  rescue Dragonfly::Job::Fetch::NotFound => err
    content_tag('i', '', class: 'fa fa-ban fa-3x', title: t('label_file_not_found'))
  end

end
