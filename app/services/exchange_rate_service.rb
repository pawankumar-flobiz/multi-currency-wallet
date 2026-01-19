require 'rest-client'
require 'json'
class ExchangeRateService
  BASE_URL = "https://v6.exchangerate-api.com/v6"

  def self.exchange_rate(from_currency:,to_currency:)
    from_currency=from_currency.upcase
    to_currency=to_currency.upcase
    url = "#{BASE_URL}/#{Settings.exchange.key}/latest/#{from_currency}"
    response = RestClient.get(url)
    data=JSON.parse(response)
    rate = data["conversion_rates"][to_currency]
    rate
    rescue RestClient::ExceptionWithResponse => e
      raise StandardError, "Exchange service unavailable"
  end
end