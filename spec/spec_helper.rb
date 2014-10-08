require "lita-env"
require "lita/rspec"
# require "rspec-redis_helper"
require "support/redis_process"

REDIS = RedisServer.new(
	host: "127.0.0.1",
	port: 6379
)

RSpec.configure do |config|
	config.before(:suite) do
		REDIS.start
	end

	config.after(:suite) do
		REDIS.stop
	end
end

# RSpec.configure do |spec|
#   spec.include RSpec::RedisHelper, redis: true

#   spec.before(:suite) do
#   	REDIS.start
#   end

#   # clean the Redis database around each run
#   # @see https://www.relishapp.com/rspec/rspec-core/docs/hooks/around-hooks
#   spec.around( :each, redis: true ) do |example|
#     with_clean_redis do
#       example.run
#     end
#   end

#   spec.after(:suite) do
#   	REDIS.stop
#   end
# end