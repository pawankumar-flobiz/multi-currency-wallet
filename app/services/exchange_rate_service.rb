require "net/http"
require "json"
class ExchangeRateService
  def self.exchange_rate(from_currency:,to_currency:)
    from_currency=from_currency.upcase
    to_currency=to_currency.upcase
    url = URI("https://v6.exchangerate-api.com/v6/#{Settings.exchange.key}/latest/#{from_currency}")

    response=Net::HTTP.get(url)
    data=JSON.parse(response)
    rate = data["conversion_rates"][to_currency]
    rate
  end
end