require 'pry'
require 'json'
module Lita
  module Handlers
    class Env < Handler

      # env add grape
    	route /env\s+add\s+(.+)/i, :add, command: true, help: {
    		t("help.add_key") => t("help.add_value")
    	}

      # env update grape opsman:1.3 cf:1.3
      route /env\s+update\s+(.+)/i, :update, command: true, help: {
        t("help.update_key") => t("help.update_value")
      }

      # env remove grape
      route /env\s+remove\s+(.+)/i, :remove, command: true, help: {
        t("help.remove_key") => t("help.remove_value")
      }

      # env list-targets
      route /env\s+list-targets/i, :list_targets, command: true, help: {
        t("help.list_targets_key") => t("help.list_targets_value")
      }

      # env list
      route /env\s+list/i, :list, command: true, help: {
        t("help.list_key") => t("help.list_value")
      }

      # env clear
      route /env\s+clear/i, :clear, command: true, help: {
        t("help.clear_key") => t("help.clear_value")
      }

      # env please clear
      route /env\s+please.clear/i, :please_clear, command: true, help: {
        t("help.please_clear_key") => t("help.please_clear_value")
      }

      # env set-target opsman:1.3
      route /env\s+set-target\s+(.+)/i, :target, command: true, help: {
        t("help.target_key") => t("help.target_value")
      }

      def add(response)
        key, value = split_message(response)

        Environment.create(key, value)
        response.reply(t("added", name: key))
      end

      def update(response)
        key, value = split_message(response)
        if Environment.exists?(key)
          response.reply(t("updated", name: response.matches[0][0]))
        else
          response.reply(t("does_not_exist", name: key))
        end
      end

      def remove(response)
        key = response.matches[0][0]
        if Environment.exists?(key)
          Environment.remove(key)
          response.reply(t("removed", name: key))
        else
          response.reply(t("does_not_exist", name: key))
        end
      end

      def list(response)
      end

      def clear(response)
        response.reply(t("clear", command: t("clear_key")))
      end

      def please_clear(response)
        Environment.destroy
        response.reply(t("cleared"))
      end

      def target(response)
        attribute = response.args[1]
        original_key,value = attribute.split(":")

        key = "target-" + original_key

        Environment.create(key,value)
        response.reply(t("set_target", key: original_key, value: value))
      end

      def list_targets(response)
        # response.reply(t(""))
      end

      def format_values_json(value)
        hash = Hash.new
        value.each do |n|
          temp = n.split(":")
          hash.store(temp.first,temp.last)
        end
        return hash.to_json
      end

      def split_message(response)
        data = response.matches[0][0].split(" ")

        # assume first word is always the environment
        env = data.first
        args = data.drop(1)

        return env, format_values_json(args)
      end

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
