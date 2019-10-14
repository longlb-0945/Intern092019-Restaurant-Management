class OrderDetailsController < ApplicationController
  before_action :append_product_price, only: :create

  def index
    @order_detail_product = OrderDetail.new
    @order_details = Order.find_by(id: params[:order_id]).order_details
  end

  def new; end

  def create
    @order_detail = OrderDetail.new order_detail_params
    if @order_detail.save
      flash.now[:success] = t "create_order_detail_suc"
      respond_to do |format|
        format.js
      end
    else
      flash.now[:danger] = t "create_order_detail_fail"
      render :index
    end
  end

  private

  def order_detail_params
    params.require(:order_detail).permit OrderDetail::ORDER_DETAIL_PARAMS
  end

  def load_product_price
    g_price = Product.find_by(id: params[:order_detail][:product_id]).price
    return g_price if g_price.present?
  end

  def append_product_price
    params[:order_detail][:price] ||= load_product_price
    params[:order_detail][:amount] ||= load_product_price
  end
end
