require 'carrierwave/storage/abstract'
require 'carrierwave/storage/file'
require 'carrierwave/storage/fog'

CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:]\.\-\+]/

CarrierWave.configure do |config|
  if Rails.env.production?
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: 'AKIAXVRFTZG676WAJLCS"',
      aws_secret_access_key: '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',
      region: 'ap-northeast-1'
    }

    config.fog_directory = 'recipeapp-s3'
    config.storage :fog
    config.cache_storage = :fog

  else
    config.storage :file
    config.enable_processing = false if Rails.env.test?
  end
  
end