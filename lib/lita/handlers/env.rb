module Lita
  module Handlers
    class Env < Handler

    	route /env\s+add\s+(.+)/i, :add, command: true, help: {
    		t("help.add_key") => t("help.add_value")
    	}

      route /env\s+update\s+(.+)/i, :update, command: true, help: {
        t("help.update_key") => t("help.update_value")
      }

      route /env\s+remove\s+(.+)/i, :remove, command: true, help: {
        t("help.remove_key") => t("help.remove_value")
      }

      route /env\s+list/i, :list, command: true, help: {
        t("help.list_key") => t("help.list_value")
      }

      route /env\s+clear/i, :clear, command: true, help: {
        t("help.clear_key") => t("help.clear_value")
      }

      route /env\s+target-opsman/i, :target, command: true, help: {
        t("help.target_key") => t("help.target_value")
      }

      route /env\s+target-cf\s+(.+)/i, :target, command: true, help: {
        t("help.target_key") => t("help.target_value")
      }

      def add(response)
        key = response.matches[0][0]
        
        Environment.create(key,"")
        response.reply(t("added", name: key))
      end

      def update(response)
        response.reply(t("updated", name: response.matches[0][0]))
      end

      def remove(response)
        response.reply(t("removed", name: response.matches[0][0]))
      end

      def list
      end

      def clear
      end

      def target(response)
        key = response.args[0]
        value = response.args[1]

        Environment.create(key,value)
        response.reply(t("set_target", key: key, value: value))
      end

    	# def add(response)
    	# 	redis.sadd("env:#{response.user.id}", response.matches[0][0])
    	# 	redis.sadd("env", response.user.id)
    	# 	response.reply(t("added environment", type: env))
    	# end

    	# def list(response)
    	# 	user_ids = redis.smembers("env")
    	# 	return if user_ids.empty?

    	# 	environments = []

    	# 	user_ids.each do |user_id|
    	# 		user = User.find_by_id(user_id)
    	# 		next unless user

    	# 		redis.smembers("env:#{user.id}").each do |details|
    	# 			environments << t("environment", name: details, user: user.name)
    	# 		end
    	# 	end

    	# 	environments.join("\n")
    	# end
    end

    Lita.register_handler(Env)
  end
end
