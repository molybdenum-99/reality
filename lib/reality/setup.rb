require 'dotenv/load'
require 'money/bank/open_exchange_rates_bank'
Money.default_bank = Money::Bank::OpenExchangeRatesBank.new.tap do |oxr|
  oxr.cache = '~/.reality/open_exchange_rate.json'
  oxr.app_id = ENV['OPEN_EXCHANGE_RATE_APP_ID']
  oxr.ttl_in_seconds = 86400
  oxr.update_rates # IDK why it should be called explicitly, hon
end
