class UserSerializer < ActiveModel::Serializer
	attributes :id, :first_name, :last_name, :username, :stocks_value, :cash_value, :stocks, :watched_stocks

  has_many :purchased_stocks




  def stocks
    self.object.purchased_stocks.map do |stock|
      {
        id: stock.id,
        name: stock.company.name,
        symbol: stock.company.symbol,
        shares: stock.shares,
        day_purchased: stock.shares,
        price_at_purchase: stock.company.current_stock_price,
        total_day_bought: stock.company.current_stock_price * stock.shares
      }
    end
  end

  def watched_stocks
    self.object.watchlists.map do |w_stock|
      {
        id: w_stock.id,
        name: w_stock.company.name,
        symbol: w_stock.company.symbol
      }
    end
  end
end
