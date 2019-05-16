class PurchasedStocksController < ApplicationController
  def index
    @purchased_stocks = PurchasedStock.all
    render json: @purchased_stocks
  end

end
