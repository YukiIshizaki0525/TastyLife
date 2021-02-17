module ApplicationHelper
  APP_NAME = 'RecipeApp'.freeze
  def page_title
    base_title = APP_NAME
    return base_title if @title.blank?
    "#{base_title} | #{@title}"
  end

  def flash_message(message, klass)
    content_tag(:div, class: "alert alert-#{klass}") do
      concat content_tag(:button, 'x', class: 'close', data: {dismiss: 'alert'})
      concat raw(message)
    end
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    link_to(name, '#', class: "js-add_fields add-field-btn", data: {id: id, fields: fields.gsub("\n", "")})
  end
end

