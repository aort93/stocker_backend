require 'net/http'

class UserSerializer < ActiveModel::Serializer
	attributes :id, :first_name, :last_name, :username, :stocks_value, :cash_value, :original_cash_value, :stocks, :watched_stocks, :array

  def stocks
    self.object.purchased_stocks.map do |stock|
      {
        id: stock.id,
        name: stock.company.name,
        symbol: stock.company.symbol,
        current_shares: stock.current_shares,
        shares_day_purchased: stock.shares,
        price_at_purchase: stock.price,
				date: stock.date_purchased,
        total_day_bought: stock.price * stock.shares
      }
    end
  end

	def array
		transactions = self.object.purchased_stocks

		tickers = transactions.map do |stock|
			stock.company.symbol.downcase
		end.uniq

		# companies_url = URI.parse("https://api.iextrading.com/1.0/stock/market/batch?symbols=#{tickers.join(',')}&types=quote")
		companies_url = URI.parse("https://cloud.iexapis.com/stable/stock/market/batch?symbols=#{tickers.join(',')}&types=quote&token=pk_a8bb38e4ca7443d6a65134cd95b51606")
    companies_codes = Net::HTTP.get_response(companies_url).body
    companies_codes_arr = JSON.parse(companies_codes)

		new_arr = []

		tickers.each do |ticker|
      total_stocks = 0
      total_val = 0
      transactions.each do |stock|
        if stock.company.symbol == ticker
          total_stocks += stock.current_shares
          total_val += stock.current_shares * stock.price
        end
      end

			if total_stocks > 0
      new_arr.push(
        {
        name: companies_codes_arr[ticker.upcase]['quote']['companyName'],
        symbol: ticker,
        current_price: companies_codes_arr[ticker.upcase]['quote']['latestPrice'],
        avg_pps: total_val / total_stocks,
        total_stocks: total_stocks,
        total_val: total_val,
        total_market_val: total_stocks * companies_codes_arr[ticker.upcase]['quote']['latestPrice'],
        percent_gain_loss: (total_val - (total_stocks * companies_codes_arr[ticker.upcase]['quote']['latestPrice']))/total_val,
        amount_gain_loss: total_val - (total_stocks * companies_codes_arr[ticker.upcase]['quote']['latestPrice']),
        })
			end
    end
    return new_arr
	end


  def watched_stocks
		def quote
			articles_url = URI.parse("https://cloud.iexapis.com/stable/stock/aapl/quote/?token=pk_a8bb38e4ca7443d6a65134cd95b51606")
	    articles_codes = Net::HTTP.get_response(articles_url).body
	    articles_codes_arr = JSON.parse(articles_codes)
		end

    self.object.watchlists.map do |w_stock|
      {
        id: w_stock.id,
        name: w_stock.company.name,
        symbol: w_stock.company.symbol,
				curr_price: quote['latestPrice']
      }
    end
  end


end
