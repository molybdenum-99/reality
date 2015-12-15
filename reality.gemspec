Gem::Specification.new do |s|
  s.name     = 'reality'
  s.version  = '0.0.1'
  s.authors  = ['Victor Shepelev']
  s.email    = 'zverok.offline@gmail.com'
  s.homepage = 'https://github.com/molibdenum-99/reality'

  s.licenses = ['MIT']

  s.require_paths = ["lib"]

  s.add_dependency 'infoboxer'

  s.add_development_dependency 'rspec', '~> 3'
  s.add_development_dependency 'rspec-its', '~> 1'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'webmock'
end
