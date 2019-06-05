class WatchListsController < ApplicationController
  def create
    @user = User.find(params[:id])
    symbol = params[:symbol]
    @company_info = StockQuote::Stock.company(symbol)
    quote = StockQuote::Stock.quote(symbol)

    company = Company.create(name: company_info.company_name, symbol: symbol, current_stock_price: quote.latest_price)
    watch = Watchlist.create(user_id: user.id, company_id: company.id, price: quote.latest_price)

    render json: @user
  end

  def destroy
    @user = User.find(params[:id])

    @watchlist_item = user.watchlists.find_by(company_id: params[:id])
    @watchlist_item.destroy!
  end
end
