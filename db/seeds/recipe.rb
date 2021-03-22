puts 'Start inserting seed "recipes" ...'

20.times do |n|
  recipe = Recipe.new({
    user_id: "1",
    title: "#{n+1}番目のレシピ",
    description: "#{n+1}番目のレシピ説明",
    ingredients_attributes: [{
      content: "材料#{n+1}",
      quantity: "分量#{n+1}"
    }],
    steps_attributes: [{
      direction: "作り方#{n+1}"
    }]
  })

  recipe.save

  puts "\"#{recipe.title}\" has created!"
end