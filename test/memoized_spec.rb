#! /usr/bin/env ruby
require 'rubygems'
require 'memoized'

describe 'memoize' do
	let(:test) do
		@spec = Class.new {
			memoize
			def ruby_version
				`ruby -v`
			end
		}.new
	end

	it 'caches correctly' do
		test.ruby_version

		test.memoized_cache[:ruby_version][[]].should === test.ruby_version
	end
end
