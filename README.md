memoized
========

I wasn't completely happy with the actual memoization gems so I made one myself.

```ruby
class Perl
  memoize
  def version
    `perl -MConfig -e 'print $Config{version};'`
  end
end

p = Perl.new
p.version # this will execute the method and cache the result
# subsequent calls will get the result from the cache

p.memoize_clear(:version) # this will clear the cache for version only
p.memoize_clear # this will clear the cache for every memoized method
# the caching is instance based, not class based, if you want class based
# caching just make a singleton :)

p.memoized_cache # this will return the cache (which is a simple Hash)
```

Memoizing already present classes from others code:

```ruby
class Shortie::Service
  class << self
    memoize :find_by_key
  end

  memoize :shorten
end
```
