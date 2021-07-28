Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'https://tasty-life.site/', 'd32nvik5ha78dd.cloudfront.net'

    resource "*",
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end