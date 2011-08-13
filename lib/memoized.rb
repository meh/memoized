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

class Class
  refine_method :method_added do |old, *args|
    memoized(args.first) if @__to_memoize__

    old.call(*args)
  end
end

class Object
  # Memoize the method +name+.
  def memoized (name=nil)
    return if @__to_memoize__ = !name

    refine_method name do |old, *args|
      if memoized_cache[name].has_key?(args)
        memoized_cache[name][args]
      else
        memoized_cache[name][__memoized_try_to_clone__(args)] = old.call(*args)
      end
    end
  end; alias memoize memoized

  # Clear the memoized cache completely or only for the method +name+
  def memoized_clear (name=nil)
    if name
      memoized_cache.delete(name.to_sym)
    else
      memoized_cache.clear
    end
  end; alias memoize_clear memoized_clear

  # Get the memoization cache
  def memoized_cache
    @__memoized_cache__ ||= Hash.new {|hash, key|
      hash[key] = {}
    }
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
