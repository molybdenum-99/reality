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

  s.files = `git ls-files bin lib LICENSE.txt *.md`.split($RS)
  s.require_paths = ["lib"]
  s.bindir = 'bin'
  s.executables << 'reality'

  s.required_ruby_version = '>= 2.3.0'

  s.add_dependency 'backports', '~> 3.11'
  # s.add_dependency 'hm', '>= 0.0.2'
  s.add_dependency 'infoboxer', '>= 0.3.2'
  s.add_dependency 'tzinfo'
  s.add_dependency 'geo_coord', '>= 0.1.0'
  s.add_dependency 'tlaw'
  s.add_dependency 'money'
  s.add_dependency 'money-open-exchange-rates'
  s.add_dependency 'tz_offset', '>= 0.0.4'
  s.add_dependency 'memoist'
  s.add_development_dependency 'wheretz'
end
