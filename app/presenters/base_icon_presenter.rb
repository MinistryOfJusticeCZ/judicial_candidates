class BaseIconFormatter < AzaharaSchema::Presenter

  def labeled_html_attribute_value(attribute, entity, **options)
    template.content_tag('div', class: 'inline-attribute') do
      val = attribute_human_value(attribute, entity)
      s = ''.html_safe
      with_real_formatter_and_attribute(attribute) do |formatter, r_attr|
        s << template.content_tag('i', '', class: formatter.icon_class_for_attribute(r_attr))
        s << template.content_tag('span', formatter.format_value_html(r_attr, val, options), class: 'value')
      end
      s
    end
  end

end
