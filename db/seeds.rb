if Rails.env.development?
  require_relative 'seeds/super_users'
end

require_relative 'db/seeds/airports.rb'
