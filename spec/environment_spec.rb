require 'spec_helper'

describe Environment, lita: true do
	subject { Environment }
	before { Environment.create("grape", "blah")}
	before { Environment.create("target-opsman", "1.3")}

	after {
		subject.all.each do |data|
			Environment.remove(data)
		end
	}

	describe '#all' do
		it "returns all Environments" do
			expect(subject.all).to match(["grape","target-opsman"])
		end
	end

	describe '#create' do
		it "sets the environment key" do
			subject.create('apple', '1.3')
			expect(subject.read('apple')).to eq('1.3')
		end

		it "sets the options key" do
			subject.create('target-cf', '1.3')
			expect(subject.read('target-cf')).to eq('1.3')
		end
	end

	describe '#read' do
		it "returns the environment status" do
			expect(subject.read('grape')).to eq('blah')
		end
	end

	describe '#remove' do
		it "creates and destroys a value" do
			subject.create('fruity', 'blah')
			subject.remove('fruity')
			expect(subject.read('fruity')).to be_nil
		end
	end

	describe '#exists' do
		it "returns true if the environment does exists" do
			expect(subject.exists?('grape')).to be true
		end

		it "returns flase if the environment doesnt exist" do
			expect(subject.exists?('orange')).to be false
		end
	end
end