class CompaniesController < ApplicationController
  def index
    @companies = Company.all

    render json: @companies
  end

  def watchlist
    user = User.find(params[:userId])
    symbol = params[:symbol]

    company_info = StockQuote::Stock.company(symbol)
    quote = StockQuote::Stock.quote(symbol)

    company = Company.create(name: company_info.company_name, symbol: symbol, current_stock_price: quote.latest_price)

    watch = Watchlist.create(user_id: user.id, company_id: company.id, price: quote.latest_price)

    render json: user
  end

  def show
    symbol = params[:id]
    company_url = URI.parse("https://cloud.iexapis.com/stable/stock/#{symbol}/company/?token=pk_a8bb38e4ca7443d6a65134cd95b51606")
    company_codes = Net::HTTP.get_response(company_url).body
    company_info = JSON.parse(company_codes)

    # comany_info = StockQuote::Stock.company(symbol)
    quotes_url = URI.parse("https://cloud.iexapis.com/stable/stock/#{symbol}/quote/?token=pk_a8bb38e4ca7443d6a65134cd95b51606")
    quotes_codes = Net::HTTP.get_response(quotes_url).body
    company = JSON.parse(quotes_codes)

    # company = StockQuote::Stock.quote(symbol)

    news_url = URI.parse("https://cloud.iexapis.com/stable/stock/#{symbol}/news/?token=pk_a8bb38e4ca7443d6a65134cd95b51606")
    news_codes = Net::HTTP.get_response(news_url ).body
    company_news = JSON.parse(news_codes)
    # company_news = StockQuote::Stock.news(symbol)

    logo_url = URI.parse("https://cloud.iexapis.com/stable/stock/#{symbol}/logo/?token=pk_a8bb38e4ca7443d6a65134cd95b51606")
    logo_codes = Net::HTTP.get_response(logo_url ).body
    logo = JSON.parse(logo_codes)
    # logo = StockQuote::Stock.logo(symbol)

    financials_url = URI.parse("https://cloud.iexapis.com/stable/stock/#{symbol}/financials/?token=pk_a8bb38e4ca7443d6a65134cd95b51606")
    financials_codes = Net::HTTP.get_response(financials_url ).body
    financials = JSON.parse(financials_codes)
    # financials = StockQuote::Stock.financials(symbol)



    render json: {
        company: company,
        company_news: company_news,
        financials: financials,
        logo: logo
    }
  end

  def portfolio
    user = User.find(params[:userId])
    transactions = user.purchased_stocks
    tickers = transactions.map do |stock|
      stock.company.symbol.downcase
    end.uniq

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
    render json: new_arr
  end

  def buy_stocks
    user = User.find(params[:userId])
    symbol = params[:symbol]
    shares = params[:shares].to_i
    date = params[:date]

    quotes_url = URI.parse("https://cloud.iexapis.com/stable/stock/#{symbol}/quote/?token=pk_a8bb38e4ca7443d6a65134cd95b51606")
    quotes_codes = Net::HTTP.get_response(quotes_url).body
    quote = JSON.parse(quotes_codes)
    # quote = StockQuote::Stock.quote(symbol)

    company_url = URI.parse("https://cloud.iexapis.com/stable/stock/#{symbol}/company/?token=pk_a8bb38e4ca7443d6a65134cd95b51606")
    company_codes = Net::HTTP.get_response(company_url).body
    company_info = JSON.parse(company_codes)
    # company_info = StockQuote::Stock.company(symbol)

    if user.cash_value > shares * quote["latestPrice"] && shares > 0
      company = Company.create(name: company_info['companyName'], symbol: symbol, current_stock_price: quote['latestPrice'])

      purch = PurchasedStock.create(user_id: user.id, company_id: company.id, shares: shares, price: quote['latestPrice'], date_purchased: date, current_shares: shares )

      user.update(cash_value: user.cash_value - purch.shares * purch.price, stocks_value: user.stocks_value + purch.shares * purch.price)


      render json: user
    else
      render json: {errors: "You don't have enough money for that!!! or You can't buy 0 stocks. Sorry"}
    end
  end

  def sell_stocks
    user = User.find(params[:userId])
    transactions = user.purchased_stocks
    symbol = params[:symbol]
    sell_amount = params[:shares].to_i
    shares = (params[:shares].to_i) * (-1)
    date = params[:date]

    quotes_url = URI.parse("https://cloud.iexapis.com/stable/stock/#{symbol}/quote/?token=pk_a8bb38e4ca7443d6a65134cd95b51606")
    quotes_codes = Net::HTTP.get_response(quotes_url).body
    quote = JSON.parse(quotes_codes)
    # quote = StockQuote::Stock.quote(symbol)

    company_url = URI.parse("https://cloud.iexapis.com/stable/stock/#{symbol}/company/?token=pk_a8bb38e4ca7443d6a65134cd95b51606")
    company_codes = Net::HTTP.get_response(company_url).body
    company_info = JSON.parse(company_codes)
    # company_info = StockQuote::Stock.company(symbol)

    total_stocks = 0
    sell_value = 0

    filtered_stock = user.purchased_stocks.filter do |stock|
      stock.company.symbol === symbol
    end

    filtered_stock.each do |stock|
      total_stocks += stock.current_shares
    end

    tickers = transactions.map do |stock|
      stock.company.symbol.downcase
    end.uniq

    exist = tickers.include?(symbol.downcase)

    if(exist && sell_amount <= total_stocks && sell_amount > 0)
      company = Company.create(name: company_info.company_name, symbol: symbol, current_stock_price: quote.latest_price)

      sold = PurchasedStock.create(user_id: user.id, company_id: company.id, shares: shares, price: quote.latest_price, date_purchased: date, current_shares: 0.0)

      filtered_stock.each do |stock|
        if stock.current_shares > 0 && sell_amount < stock.current_shares
          new_val = stock.current_shares - sell_amount
          stock.update(current_shares: new_val)
          user.update(cash_value: user.cash_value + (sell_amount * quote.latest_price), stocks_value: user.stocks_value - (sell_amount * quote.latest_price))
          sell_amount = 0
        elsif stock.current_shares > 0 && sell_amount >= stock.current_shares
          stock.update(current_shares: 0)
          sell_amount - stock.current_shares
          user.update(cash_value: user.cash_value + (sell_amount * quote.latest_price), stocks_value: user.stocks_value - (sell_amount * quote.latest_price))
        end
      end
      new_user = User.find(params[:userId])
      render json: new_user
    else
      render json: {errors: "You don't own that many stocks!"}
    end
  end

end
