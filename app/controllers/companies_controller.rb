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

  def retrieve


  end
end
