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
    comany_info = StockQuote::Stock.company(symbol)
    company = StockQuote::Stock.quote(symbol)
    company_news = StockQuote::Stock.news(symbol)
    logo = StockQuote::Stock.logo(symbol)
    financials = StockQuote::Stock.financials(symbol)



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

    companies_url = URI.parse("https://api.iextrading.com/1.0/stock/market/batch?symbols=#{tickers.join(',')}&types=quote")
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
    quote = StockQuote::Stock.quote(symbol)
    company_info = StockQuote::Stock.company(symbol)


    if user.cash_value > shares * quote.latest_price && shares > 0
      company = Company.create(name: company_info.company_name, symbol: symbol, current_stock_price: quote.latest_price)

      purch = PurchasedStock.create(user_id: user.id, company_id: company.id, shares: shares, price: quote.latest_price, date_purchased: date, current_shares: shares )

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
    quote = StockQuote::Stock.quote(symbol)
    company_info = StockQuote::Stock.company(symbol)

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
