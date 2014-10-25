require "spec_helper"
require "redis"
describe Lita::Handlers::Env, lita_handler: true do

	let(:user) {Lita::User.create(2, name:"Test User")}
	let(:environment) { "grape"}
	let(:missing_environment) { "apple" }
	let(:opsman_target) { "1.3" }
	let(:cf_target) { "1.3" }
	let(:opsman_data) { "opsman:1.3" }
	let(:cf_data) { "cf:1.3" }

	it { routes_command("env add #{environment}").to(:add) }
	it { routes_command("env update #{environment}").to(:update) }
	it { routes_command("env remove #{environment}").to(:remove) }
	it { routes_command("env list").to(:list) }
	it { routes_command("env clear").to(:clear) }
	it { routes_command("env target-opsman #{opsman_target}").to(:target) }
	it { routes_command("env target-cf #{cf_target}").to(:target)}

	before(:each) do
		send_command("env add #{environment} #{opsman_data} #{cf_data}")
	end

  it "has access to redis" do
    expect(Environment.redis).to_not be_nil
  end

  context "when adding a  new environment it" do
		it "should return the correct message" do
			expect(replies.last).to eq("Added environment #{environment}")
		end

		it "should store the correct json value" do
			value = Environment.read(environment)
			expect(value).to eq("{\"opsman\":\"1.3\",\"cf\":\"1.3\"}")
		end
	end

	context "when updating an existing environment" do
		it "updates existing environment" do
			send_command("env update #{environment}")
			expect(replies.last).to eq("Updated environment details for #{environment}")
		end
	end

	context "when updating a non-existent environment" do
		it "should give an error message" do
		end
	end

	context "when removing an existing environment it" do
		before(:each) do
			send_command("env remove #{environment}")
		end

		it "should return the correct message" do
			expect(replies.last).to eq("Removed environment #{environment}")
		end

		it "should not exist in Redis" do
			value = Environment.read(environment)
			expect(value).to be_nil
		end
	end

	context "when removing a non-existent environment it" do
		before(:each) do
			send_command("env remove #{missing_environment}")
		end

		it "should return the correct message" do
			expect(replies.last).to eq("Environment #{missing_environment} does not exist")
		end
	end

	context "when listing all environments it" do
	end

	context "when clearing all environments" do
		context "which is not confirmed" do
			before(:each) do
				send_command("env clear")
			end

			it "should ask for confirmation" do
				expect(replies.last).to eq("To confirm you really want to clear all environments type 'env please clear'")
			end
		end

		context "which is confirmed" do
			before(:each) do
				send_command("env please clear")
			end

			it "should return the correct message" do
				expect(replies.last).to eq("Successfully removed all environments")
			end

			it "should remove all environments from Redis" do
				keys = Environment.all
				expect(keys).to be_empty
			end

		end
	end

	it "clears all environments" do
	end

	describe "updates OpsManager target" do

		it "and shows the correct message" do
			send_command("env target-opsman 1.3")
			expect(replies.last).to eq("Config for target-opsman target value set to 1.3")
		end

		it "and updates Redis" do
			send_command("env target-opsman 1.3")
			expect(Environment.read("target-opsman")).to eq("1.3")
		end

	end

	describe "updates CloudFoundry target" do

		it "and shows the correct message" do
			send_command("env target-cf 1.3")
			expect(replies.last).to eq("Config for target-cf target value set to 1.3")
		end

		it "and updates Redis" do
			send_command("env target-cf 1.3")
			expect(Environment.read("target-cf")).to eq("1.3")
		end
	end
end