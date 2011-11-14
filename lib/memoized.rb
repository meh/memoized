#--
#          DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                  Version 2, December 2004
#
# Copyleft meh.
#
#          DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
# TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION 
#
# 0. You just DO WHAT THE FUCK YOU WANT TO.
#++

require 'refining'

class Module
	refine_method :method_added, :prefix => '__memoized' do |name|
		next if name == 'temporary method for refining'

		memoized(name) if @__to_memoize__

		__memoized_method_added(name)
	end

	refine_method :singleton_method_added, :prefix => '__memoized' do |name|
		next if name == 'temporary method for refining'

		singleton_memoized(name) if @__to_singleton_memoize__

		__memoized_singleton_method_added(name)
	end
end

class Object
	# Memoize the method +name+.
	def memoized (name = nil)
		return if @__to_memoize__ = !name

		to_call = "__memoized_#{name}"

		begin; if instance_method(name).arity == 0
			refine_method name, :prefix => '__memoized' do
				(memoized_cache[name][nil] ||= [__send__(to_call)])[0]
			end

			return
		end; rescue; end

		refine_method name, :prefix => '__memoized' do |*args|
			if tmp = memoized_cache[name][args]
				tmp[0]
			else
				memoized_cache[name][__memoized_try_to_clone__(args)] = [__send__(*([to_call] + args))]
			end
		end

		nil
	end; alias memoize memoized

	# Memoize the singleton method +name+.
	def singleton_memoized (name = nil)
		return if @__to_singleton_memoize__ = !name

		to_call = "__memoized_#{name}"

		begin; if method(name).arity == 0
			refine_singleton_method name, :prefix => '__memoized' do
				(memoized_cache[name][nil] ||= [__send__(to_call)])[0]
			end

			return
		end; rescue; end

		refine_singleton_method name, :prefix => '__memoized' do |*args, &block|
			if tmp = memoized_cache[name][args]
				tmp[0]
			else
				memoized_cache[name][__memoized_try_to_clone__(args)] = [__send__(*([to_call] + args))]
			end
		end

		nil
	end; alias singleton_memoize singleton_memoized

	# Clear the memoized cache completely or only for the method +name+
	def memoized_clear (name = nil)
		if name
			memoized_cache.delete(name.to_sym)
		else
			memoized_cache.clear
		end
	end; alias memoize_clear memoized_clear

	# Get the memoization cache
	def memoized_cache
		@__memoized_cache__ ||= Hash.new { |h, k| h[k] = {} }
	end; alias memoize_cache memoized_cache

	private

	def __memoized_try_to_clone__ (value) # :nodoc:
		begin
			Marshal.load(Marshal.dump(value))
		rescue Exception
			value
		end
	end
end
