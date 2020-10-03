module ApplicationHelper
  APP_NAME = 'RecipeApp'.freeze
  def page_title
    base_title = APP_NAME
    return base_title if @title.blank?
    "#{base_title} | #{@title}"
  end
  
  def header_link_item(name, path)
    class_name = 'nav-item'
    # 表示するページと引数のpathが等しい場合、class_nameにactiveを追加
    class_name << ' active' if current_page?(path)

    content_tag :li, class: class_name do
      link_to name, path, class: 'nav-link'
    end
  end


  def flash_message(message, klass)
    content_tag(:div, class: "alert alert-#{klass}") do
      concat content_tag(:button, 'x', class: 'close', data: {dismiss: 'alert'})
      concat raw(message)
    end
  end
end
