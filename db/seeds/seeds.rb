require './db/seeds/user.rb'
require './db/seeds/tag.rb'

Dir[File.expand_path('./db/seeds' << '/*.rb')].each do |file|
  require file
end