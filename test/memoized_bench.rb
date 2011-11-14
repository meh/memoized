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
		@b ||= {}
		
		if @b.has_key?([a, b])
			@b[[a, b]]
		else
			@b[[a, b]] = a + b
		end
	end

	def self.c (a, b)
		@c ||= {}

		(@c[[a, b]] ||= [a + b])[0]
	end
end

Benchmark.bm do |b|
	b.report('memoized: ') {
		100_000.times { LOL.a(2, 2) == 4 }
	}

	b.report('ivar ||=: ') {
		100_000.times { LOL.b(2, 2) == 4}
	}

	b.report('wrapper: ') {
		100_000.times { LOL.c(2, 2) == 4}
	}
end
