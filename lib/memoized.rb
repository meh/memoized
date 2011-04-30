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
  alias __old_memoized_method_added method_added

  def method_added (name)
    if @__to_memoize__
      memoize(name)
    end

    __old_memoized_method_added(name)
  end
end

class Object
  # Memoize the method +name+. If +file+ is provided, then the method results
  # are stored on disk as well as in memory.
  def memoize (name=nil)
    if !name
      return @__to_memoize__ = true
    end
    
    @__to_memoize__ = false

    name = name.to_sym
    meth = self.instance_method(name)

    define_method name do |*args|
      memoized_cache[[name] + [args]] ||= meth.bind(self).call(*args)
    end
  end

  # Clear the memoized cache completely or only for the method +name+
  def memoize_clear (name=nil, file=nil)
    if name
      memoized_cache.delete(name.to_sym)
    else
      memoized_cache.clear
    end
  end

  def memoized_cache
    @__memoized_cache__ ||= {}
  end
end
