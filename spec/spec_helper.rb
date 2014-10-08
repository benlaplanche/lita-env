require "lita-env"
require "lita/rspec"
require "support/redis_process"

REDIS = RedisServer.new(
	host: "127.0.0.1",
	port: 6379
)

RSpec.configure do |config|
	config.before(:suite) do
		REDIS.start
		sleep 1
	end

	config.after(:suite) do
		REDIS.stop
	end
end