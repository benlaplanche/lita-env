require "spec_helper"

describe Lita::Handlers::Env, lita_handler: true do
	let(:user) {Lita::User.create(2, name:"Test User")}
	let(:environment) { "grape"}
	let(:missing_environment) { "apple" }
	let(:opsman_target) { "1.3" }
	let(:cf_target) { "1.3" }

	it { routes_command("env add #{environment}").to(:add) }
	it { routes_command("env update #{environment}").to(:update) }
	it { routes_command("env remove #{environment}").to(:remove) }
	it { routes_command("env list").to(:list) }
	it { routes_command("env clear").to(:clear) }
	it { routes_command("env target-opsman #{opsman_target}").to(:target) }
	it { routes_command("env target-cf #{cf_target}").to(:target)}

	it "adds new enviroment" do
		send_command("env add #{environment}")
		expect(replies.last).to eq("Added environment #{environment}")
	end

	it "updates existing environment" do
		send_command("env update #{environment}")
		expect(replies.last).to eq("Updated environment details for #{environment}")
	end

	it "updates a missing environment" do
	end

	it "removes an existing environment" do
		send_command("env remove #{environment}")
		expect(replies.last).to eq("Removed environment #{environment}")
	end

	it "removes a missing environment" do
	end

	it "lists all environments" do
	end

	it "clears all environments" do
	end

	it "updates OpsManager target" do
		send_command("env target-opsman 1.3")
		expect(replies.last).to eq("opsman")
	end

	it "updates CloudFoundry target" do
		send_command("env target-cf 1.3")
		expect(replies.last).to eq("cf")
	end

end
