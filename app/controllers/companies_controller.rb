class CompaniesController < ApplicationController
  def index
    @companies = Company.all

    render json: @companies
  end

  def show
    symbol = params[:id]
    company = StockQuote::Stock.quote(symbol)
    company_news = StockQuote::Stock.news(symbol)
    logo = StockQuote::Stock.logo(symbol)
    render json: {

        company: company,
        company_news: company_news,
        logo: logo

    }
  end

  def buy_stocks
    user = User.find(params[:userId])
    symbol = params[:symbol]
    shares = params[:shares].to_i
    date = params[:date]
    quote = StockQuote::Stock.quote(symbol)
    company_info = StockQuote::Stock.company(symbol)


    if user.cash_value > shares * quote.latest_price
      company = Company.create(name: company_info.company_name, symbol: symbol, current_stock_price: quote.latest_price)

      purch = PurchasedStock.create(user_id: user.id, company_id: company.id, shares: shares, price: quote.latest_price, date_purchased: date, current_shares: shares )

      user.update(cash_value: user.cash_value - purch.shares * purch.price, stocks_value: user.stocks_value + purch.shares * purch.price)


      render json: user
    else
      render json: {errors: "You don't have enough money for that!!!"}
    end
  end

  def sell_stocks
    user = User.find(params[:userId])
    symbol = params[:symbol]
    sell_amount = params[:shares].to_i
    shares = (params[:shares].to_i) * (-1)
    date = params[:date]
    quote = StockQuote::Stock.quote(symbol)
    company_info = StockQuote::Stock.company(symbol)

    total_stocks = 0
    sell_value = 0

    company = Company.create(name: company_info.company_name, symbol: symbol, current_stock_price: quote.latest_price)

    sold = PurchasedStock.create(user_id: user.id, company_id: company.id, shares: shares, price: quote.latest_price, date_purchased: date, current_shares: 0.0)

    filtered_stock = user.purchased_stocks.filter do |stock|
      stock.company.symbol === symbol
    end

    filtered_stock.each do |stock|
      total_stocks += stock.current_shares
    end


    if (sell_amount <= total_stocks)
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
      render json: user
    else
      render json: {errors: "You don't own that many stocks!"}
    end
  end


end
