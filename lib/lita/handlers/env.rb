module Lita
  module Handlers
    class Env < Handler

    	route /env\s+add, :add_env, command: true, help: {
    		"env add" => t("add a new environment")
    	}

    	route /env\s+list, :list_env, command: true, help: {
    		"env list" => t("shows status of current environments")
    	}

    	def add_env(response)
    		redis.sadd("env:#{response.user.id}", response.matches[0][0])
    		redis.sadd("env", response.user.id)
    		response.reply(t("added environment", type: env))
    	end

    	def list_env(response)
    		user_ids = redis.smembers("env")
    		return if user_ids.empty?

    		environments = []

    		user_ids.each do |user_id|
    			user = User.find_by_id(user_id)
    			next unless user

    			redis.smembers("env:#{user.id}").each do |details|
    				environments << t("environment", name: details, user: user.name)
    			end
    		end

    		environments.join("\n")
    	end
    end

    Lita.register_handler(Env)
  end
end
