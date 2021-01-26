module RecipesHelper
  def render_with_tags(name, tag_id)
    name.gsub(/[\w\p{Han}ぁ-ヶｦ-ﾟー]+/){|word| link_to word, "/recipes/tag/#{word.delete("#")}?tag_id=#{tag_id}", class: 'tag__item'}.html_safe
  end
end