require 'spec_helper'

describe Environment, lita: true do
	subject { Environment }
	before { Environment.create("grape", "blah")}
	before { Environment.create("target-opsman", "1.3")}

	after {
		subject.all.each do |data|
			Environment.destroy(data)
		end
	}

	describe '#all' do
		it "returns all Environments" do
			expect(subject.all).to match(["grape","target-opsman"])
		end
	end

	describe '#create' do
		it "sets the key as the environment name and value as environment properties" do
			subject.create('target-cf', '1.3')
			expect(subject.read('target-cf')).to eq('1.3')
		end
	end

	describe '#read' do
	end

	describe '#destroy' do
	end

	describe '#exists' do
	end
end