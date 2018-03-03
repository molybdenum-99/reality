source 'https://rubygems.org'

# Used on developing a new version, which typically requires some updates
# and bug fixes on underlying stuff:

#gem 'mediawiktory', path: '/home/zverok/gems/mediawiktory'
#gem 'infoboxer', path: '/home/zverok/gems/infoboxer'
gem 'hm', path: '/home/zverok/gems/hm'

gemspec

group :docs do
  gem 'yard'
  gem 'dokaz', github: 'zverok/dokaz'
end

group :development do
  #gem 'progress_bar', github: 'zverok/progress_bar'
  gem 'saharspec', github: 'zverok/saharspec'

  gem 'nokogiri'
  gem 'addressable'
  gem 'naught'
  gem 'faraday'
  gem 'faraday_middleware'
  #gem 'progress_bar'
  gem 'rake'
  gem 'rubygems-tasks'
  gem 'dotenv'
end

group :test do
  gem 'rspec', '~> 3'
  gem 'rspec-its', '~> 1'
  gem 'vcr'
  gem 'webmock'
  gem 'timecop'
end
