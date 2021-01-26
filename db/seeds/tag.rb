if Rails.env == 'development'
  Tag.create([
    { name: '肉料理' },
    { name: '魚介料理' },
    { name: '野菜料理' },
    { name: 'ご飯もの' },
    { name: '麺類' }
  ])
end