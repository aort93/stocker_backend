class UsersController < ApplicationController
  def index
    @users = User.all
    render json: @users
  end

  def show
    @user = User.find(params[:id])
    render json: @user
  end





  def update_user_stock_val
    total = 0
    @user = User.find(params[:id])
    my_purchased_stocks = @user.purchased_stocks


    my_purchased_stocks.each do |stock|
      stock_symbol = stock.company.symbol
      total += StockQuote::Stock.quote(stock_symbol).latest_price
    end

    @current_cash = @user.cash_value
    @buying_power = @user.cash_value + total



    render json: {
      total_stock_investment: total,
      current_cash: @current_cash,
      buying_power: @buying_power
    }
  end


  def create
		user = User.new(
			first_name: params[:first_name],
      last_name: params[:last_name],
			username: params[:username],
			password: params[:password],
			stocks_value: 0,
			cash_value: params[:cash]
		)

		if user.save
			token = encode_token(user.id)


      render json: {user: UserSerializer.new(user), token:token}
		else
			render json: {errors: user.errors.full_messages}
		end
	end
end
