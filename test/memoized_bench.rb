#! /usr/bin/env ruby
require 'rubygems'
require 'benchmark'
require 'memoized'

class LOL
	singleton_memoize
	def self.a (a, b)
		a + b
	end

	def self.b (a, b)
		@result ||= {}
		
		if @result.has_key?([a, b])
			@result[[a, b]]
		else
			@result[[a, b]] = a + b
		end
	end
end

Benchmark.bm do |b|
	b.report('memoized: ') {
		10_000.times { LOL.a(2, 2) == 4 }
	}

	b.report('ivar ||=: ') {
		10_000.times { LOL.b(2, 2) == 4}
	}
end
