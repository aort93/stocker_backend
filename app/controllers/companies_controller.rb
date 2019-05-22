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
    shares = params[:shares]
    quote = StockQuote::Stock.quote(symbol)
    company_info = StockQuote::Stock.company(symbol)
    total_paid =

    # Company.create()
    company = Company.create(name: company_info.company_name, symbol: symbol, bio:company_info.description, ceo: company_info.ceo, founding_year: 10-10-2005, employee_count: 20000, location: "NewYork", current_stock_price: quote.latest_price.to_i)

    purch = PurchasedStock.create(user_id: user.id, company_id: company.id, shares: shares, price: quote.latest_price.to_i )

    render json: purch
  end


end
