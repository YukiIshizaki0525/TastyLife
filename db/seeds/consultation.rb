puts 'Start inserting seed "recipes" ...'

20.times do |n|
  consultation = Consultation.new{[
    user_id: "1",
    title: "相談#{n+1}",
    content: "相談#{n+1}の内容"
  ]}

  consultation.save

  puts "\"#{consultation.title}\" has created!"
end