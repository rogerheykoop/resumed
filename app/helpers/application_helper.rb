module ApplicationHelper
 def conditional_div(options={}, &block)
    if options.delete(:show_div)
      concat content_tag(:div, capture(&block), options)
    else
      concat capture(&block)
    end
  end
end
