class AuthController < ApplicationController
  def login
    user = User.find_by(username: params[:username])


    if user && user.authenticate(params[:password])
      token = encode_token(user.id)

      # render json: user
      render json: {user: UserSerializer.new(user), token: token}
    else
      render json: {errors: "Incorrect username/password"}
    end
  end

  def auto_login
    # byebug
    if curr_user
      render json: curr_user
    else
      render json: {errors: "You dun goofed!"}
    end
  end

end
