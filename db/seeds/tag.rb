if Rails.env == 'development'
  Tag.create([
    { name: '栄養満点' },
    { name: '簡単' },
    { name: '時短' },
    { name: 'コスパ◎' },
    { name: '日持ち◎' },
    { name: 'おもてなし' }
  ])
end