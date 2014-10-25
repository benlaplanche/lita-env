class Environment
	REDIS_NAMESPACE = "handlers:env"
	REDIS_KEY = 'env'

	class << self

		def all
			redis.hkeys(REDIS_KEY)
		end

		def create(key,value)
			# return false if self.exists?(key)
			redis.hset(REDIS_KEY,key,value)
		end

		def read(key)
			redis.hget(REDIS_KEY, key)
		end

		def destroy(key)
			redis.hdel(REDIS_KEY, key)
		end

		def exists?(key)
			redis.hexists(REDIS_KEY, key)
		end

		def redis
			@redis ||= Redis::Namespace.new(REDIS_NAMESPACE, redis: Lita.redis)
		end
	end
end