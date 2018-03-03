begin
  require 'dotenv/load'
rescue LoadError
end

require 'money/bank/open_exchange_rates_bank'

if ENV.key?('OPEN_EXCHANGE_RATE_APP_ID')
  # Money.default_bank = Money::Bank::OpenExchangeRatesBank.new.tap do |oxr|
  #   oxr.cache = File.expand_path('~/.reality/open_exchange_rate.json')
  #   oxr.app_id = ENV['OPEN_EXCHANGE_RATE_APP_ID']
  #   oxr.ttl_in_seconds = 86400
  #   oxr.update_rates # Fetch them from cache or URL...
  #   oxr.save_rates # And save to cache if fetched. Weird API, seriously.
  # end
end
