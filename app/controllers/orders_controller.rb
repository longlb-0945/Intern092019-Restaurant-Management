class OrdersController < ApplicationController
  before_action :authenticate_user!, except: %i(new create)

  def new
    @order = Order.new
  end

  def create
    @order = Order.new order_params
    if @order.save
      flash[:success] = t "order_create_suc"
      redirect_to root_path
    else
      flash[:danger] = t "order_create_fail"
      render :new
    end
  end

  private
  def order_params
    params.require(:order).permit Order::ORDER_PARAMS
  end
end
