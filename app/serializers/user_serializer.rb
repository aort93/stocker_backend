class UserSerializer < ActiveModel::Serializer
	attributes :id, :first_name, :last_name, :username, :stocks_value, :cash_value, :stocks





  def stocks
    self.object.purchased_stocks.map do |stock|
      {
        id: stock.id,
        name: stock.company.name,
        shares: stock.shares,
        day_purchased: stock.shares,
        price_at_purchase: stock.company.current_stock_price,
        total_day_bought: stock.company.current_stock_price * stock.shares
      }
    end
  end
end
