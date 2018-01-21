source 'https://rubygems.org'

gem 'infoboxer', github: 'molybdenum-99/infoboxer', branch: 'develop'
gem 'geo_coord', github: 'zverok/geo_coord', branch: 'bigdecimal'
#gem 'infoboxer', '~> 0.3.0'

gemspec

group :docs do
  gem 'yard'
  gem 'dokaz', github: 'zverok/dokaz'
end

group :development do
  gem 'progress_bar', github: 'zverok/progress_bar'
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
