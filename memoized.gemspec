Gem::Specification.new {|s|
	s.name         = 'memoized'
	s.version      = '0.0.7.8'
	s.author       = 'meh.'
	s.email        = 'meh@paranoici.org'
	s.homepage     = 'http://github.com/meh/memoized'
	s.platform     = Gem::Platform::RUBY
	s.summary      = 'A simple library to memoize methods. Moved to https://github.com/meh/ruby-call-me'
	s.files        = Dir.glob('lib/**/*.rb')
	s.require_path = 'lib'

	s.add_dependency 'refining'

	s.add_development_dependency 'rake'
	s.add_development_dependency 'rspec'
}
