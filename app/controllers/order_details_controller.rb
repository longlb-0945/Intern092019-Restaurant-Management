class OrderDetailsController < ApplicationController
  def index
    @order_detail_product = OrderDetail.new
    return if @order_details = Order.find_by(id: params[:order_id])
                                    .order_details.includes(product: :picture)

    flash[:danger] = t "order_detail_not_found"
    redirect_to orders_path
  end

  def new; end

  def create
    @order_detail = OrderDetail.new order_detail_params
    if @order_detail.save
      flash.now[:success] = t "create_order_detail_suc"
      respond_to :js
    else
      flash.now[:danger] = t "create_order_detail_fail"
      render :index
    end
  end

  private

  def order_detail_params
    params.require(:order_detail).permit(OrderDetail::ORDER_DETAIL_PARAMS)
          .merge(price: load_product_price, amount: load_product_price)
  end

  def load_product_price
    g_price = Product.find_by(id: params[:order_detail][:product_id]).price
    return g_price if g_price.present?
  end
end
