class CompaniesController < ApplicationController
  def index
    @companies = Company.all

    render json: @companies
  end

  def show
    symbol = params[:id]
    company = StockQuote::Stock.quote(symbol)
    render json: company
  end

  def retrieve


  end
end
