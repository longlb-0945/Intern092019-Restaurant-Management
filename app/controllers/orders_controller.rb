class OrdersController < ApplicationController
  def index
    @orders = Order.page(params[:page]).per Settings.pagenate_orders
  end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new order_params
    if @order.save
      flash[:success] = t "create_order_suc"
      redirect_to orders_path
    else
      flash[:danger] = t "create_order_fail"
      render :new
    end
  end

  private

  def order_params
    params.require(:order).permit Order::ORDER_PARAMS
  end
end
