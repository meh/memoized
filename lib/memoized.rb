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

class Class
  old = self.instance_method(:method_added)

  define_method(:method_added) do |*args|
    if @__to_memoize__
      memoized(args.first)
    end

    old.bind(self).call(*args)
  end
end

class Object
  # Memoize the method +name+. If +file+ is provided, then the method results
  # are stored on disk as well as in memory.
  def memoized (name=nil)
    if name
      @__to_memoize__ = false
    else
      return @__to_memoize__ = true
    end

    name = name.to_sym
    meth = self.instance_method(name)

    define_method name do |*args|
      if tmp = memoized_cache[[name] + [args]]
        tmp
      else
        memoized_cache[[name] + [__memoized_try_to_clone__(args)]] = meth.bind(self).call(*args)
      end
    end
  end; alias memoize memoized

  # Clear the memoized cache completely or only for the method +name+
  def memoized_clear (name=nil, file=nil)
    if name
      memoized_cache.delete(name.to_sym)
    else
      memoized_cache.clear
    end
  end; alias memoize_clear memoized_clear

  def memoized_cache
    @__memoized_cache__ ||= {}
  end; alias memoize_cache memoized_cache

  private
    def __memoized_try_to_clone__ (value)
      Marshal.load(Marshal.dump(value)) rescue value
    end
end
