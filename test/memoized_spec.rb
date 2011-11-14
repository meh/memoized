#! /usr/bin/env ruby
require 'rubygems'
require 'memoized'

class LOL
	singleton_memoize
	def self.ruby_version
		`ruby -v`
	end

	singleton_memoize
	def self.add (a, b)
		a + b
	end

	memoize
	def ruby_version
		`ruby -v`
	end

	memoize
	def add (a, b)
		a + b
	end
end

describe 'memoize' do
	let(:test) do
		LOL.new
	end

	describe 'singleton' do
		it 'correctly caches methods with no argument' do
			LOL.ruby_version

			LOL.memoized_cache[:ruby_version].should == LOL.ruby_version
		end

		it 'correctly cache methods with arguments' do
			LOL.add 2, 2

			LOL.memoized_cache[:add][[2, 2]].should == [LOL.add(2, 2)]
		end
	end

	describe 'instance' do
		it 'correctly caches methods with no argument' do
			test.ruby_version

			test.memoized_cache[:ruby_version].should == test.ruby_version
		end

		it 'correctly cache methods with arguments' do
			test.add 2, 2

			test.memoized_cache[:add][[2, 2]].should == [test.add(2, 2)]
		end

	end
end
