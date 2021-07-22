if defined?(AssetSync)
  AssetSync.configure do |config|
    config.fog_provider = 'AWS'
    config.fog_directory = ENV['S3_BUCKET']
    config.aws_access_key_id = ENV['S3_ACCESS_KEY_ID']
    config.aws_secret_access_key = ENV['S3_SECRET_ACCESS_KEY']
    config.aws_session_token = ENV['AWS_SESSION_TOKEN'] if ENV.key?('AWS_SESSION_TOKEN')
    config.fog_region =  ENV['S3_REGION']

    config.run_on_precompile = false
    config.add_local_file_paths do
      public_root = Rails.root.join("public")
      Dir.chdir(public_root) do
        packs_dir = Webpacker.config.public_output_path.relative_path_from(public_root)
        Dir[File.join(packs_dir, '/**/**')]
      end
    end
  end
end
