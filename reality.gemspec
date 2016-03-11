require_relative 'lib/reality/version'

Gem::Specification.new do |s|
  s.name     = 'reality'
  s.version  = Reality::VERSION
  s.authors  = ['Victor Shepelev and contributors']
  s.email    = 'zverok.offline@gmail.com'
  s.homepage = 'https://github.com/molybdenum-99/reality'

  s.summary = 'Simple and easy proxy to real-life knowledge.'
  s.description = <<-EOF
    Reality provides access to knowledge about real world (like geography,
    history, people, movies and so on) by the means of Wikipedia and
    other open data sources.
  EOF
  s.licenses = ['MIT']

  s.files = `git ls-files`.split($RS).reject do |file|
    file =~ /^(?:
    spec\/.*
    |Gemfile
    |Rakefile
    |\.rspec
    |\.gitignore
    |\.rubocop.yml
    |\.travis.yml
    )$/x
  end
  s.require_paths = ["lib"]
  s.bindir = 'bin'
  s.executables << 'reality'

  s.add_dependency 'infoboxer', '>= 0.2.3'
  s.add_dependency 'hashie'
  s.add_dependency 'open-weather'
  s.add_dependency 'quandl'
  s.add_dependency 'timezone', '>= 0.99.0'
  s.add_dependency 'geokit'
  s.add_dependency 'tzinfo'
  s.add_dependency 'ruby-sun-times'
  s.add_dependency 'time_boots'

  s.add_development_dependency 'rspec', '~> 3'
  s.add_development_dependency 'rspec-its', '~> 1'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'webmock'
end
