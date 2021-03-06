class UsersController < ApplicationController
  def index
    @users = User.all
    render json: @users
  end

  def show
    @user = User.find(params[:id])
    render json: @user
  end

  def create
		user = User.new(
			first_name: params[:first_name],
      last_name: params[:last_name],
			username: params[:username],
			password: params[:password],
			stocks_value: 0,
			cash_value: params[:cash],
      original_cash_value: params[:cash]
		)

		if user.save
			token = encode_token(user.id)


      render json: {user: UserSerializer.new(user), token:token}
		else
			render json: {errors: user.errors.full_messages}
		end
	end
end
