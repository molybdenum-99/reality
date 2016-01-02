Gem::Specification.new do |s|
  s.name     = 'reality'
  s.version  = '0.0.1'
  s.authors  = ['Victor Shepelev']
  s.email    = 'zverok.offline@gmail.com'
  s.homepage = 'https://github.com/molibdenum-99/reality'

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

  s.add_dependency 'infoboxer', '>= 0.2.2'

  s.add_development_dependency 'rspec', '~> 3'
  s.add_development_dependency 'rspec-its', '~> 1'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'webmock'
end
