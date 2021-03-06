class DiscountsController < ApplicationController
  before_action :load_merchant

  def index
  end

  def new
  end

  def show
    @discount = @merchant.discounts.find_by_id(params[:id])
  end

  def create
    @merchant.discounts.create!(discount_params)
    redirect_to merchant_discounts_path(@merchant.id)
  end

  def edit
    @discount = @merchant.discounts.find_by_id(params[:id])
  end

  def update
    @discount = @merchant.discounts.find_by_id(params[:id])
    if @discount.update(discount_params)
      flash.notice = "Discount Successfully Updated"
      redirect_to merchant_discount_path(@merchant, @discount)
    else
      flash.notice = "Discount Update Failed"
      redirect_to edit_merchant_discount_path(@merchant, @discount)
    end
  end

  def destroy
    @merchant.discounts.find_by_id(params[:id]).destroy
    redirect_to merchant_discounts_path(@merchant.id)
  end

  private

  def load_merchant
    @merchant = Merchant.find_by_id(params[:merchant_id])
  end

  def discount_params
    params.require(:discount).permit(:name, :percentage_discount, :quantity_threshold)
  end

end
