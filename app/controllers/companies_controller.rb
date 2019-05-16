class CompaniesController < ApplicationController
  def index
    @companies = Company.all

    render json: @companies
  end

  def show
    @company = User.find(params[:id])
    render json: @company
  end
end
