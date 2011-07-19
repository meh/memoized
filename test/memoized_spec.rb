#! /usr/bin/env ruby
require 'rubygems'
require 'memoized'

describe 'memoize' do
  before do
    @spec = Class.new {
      memoize
      def ruby_version
        `ruby -v`
      end
    }.new
  end

  it 'caches correctly' do
    @spec.ruby_version

    @spec.memoized_cache[:ruby_version][[nil]].should === @spec.ruby_version
  end
end
