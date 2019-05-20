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
    @user = User.find(3)
    # byebug
    @symbol = @user.purchased_stocks[0].company.symbol

    #map over stock and add each val to total
    @stock_total = StockQuote::Stock.quote(@symbol).latest_price

    @current_cash = @user.cash_value - @stock_total
    @buying_power = @user.cash_value + @stock_total


    render json: {
      total_stock_investment: @stock_total,
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
			stocks_value: 100,
			cash_value: 100
		)

		if user.save
			token = encode_token(user.id)


      render json: {user: UserSerializer.new(user), token:token}
		else
			render json: {errors: user.errors.full_messages}
		end
	end
end
