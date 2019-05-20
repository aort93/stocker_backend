class CompanySerializer < ActiveModel::Serializer
  attributes :id, :name, :symbol, :bio, :ceo, :founding_year, :employee_count, :location, :current_stock_price, :retrieve_customers




def retrieve_customers
  self.object.purchased_stocks.map do |stock|
    {
      id: stock.user.id,
      username: stock.user.username,
      amount_of_shares: stock.shares,
      price: stock.price / stock.shares,
      total_paid: stock.price
    }
  end
end

end
