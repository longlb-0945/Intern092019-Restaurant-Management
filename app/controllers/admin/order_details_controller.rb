class Admin::OrderDetailsController < AdminController
  before_action :not_login
  before_action :guest_not_allow
  before_action :load_order_detail, only: %i(update_amount destroy)
  before_action :load_order, only: %i(index)

  def index
    access_denied if @order.pending? || @order.cancel?
    @order_detail_product = OrderDetail.new
    return if @order_details = @order.order_details
                                     .includes(product:
                                      {image_attachment: :blob})

    flash[:danger] = t "order_detail_not_found"
    redirect_to admin_orders_path
  end

  def new; end

  def create
    @order_detail = OrderDetail.new order_detail_params
    create_order_detail_transaction
  rescue StandardError
    flash[:danger] = t "create_order_detail_fail"
    redirect_to admin_order_order_details_path
  end

  def destroy
    destroy_order_detail_transaction
    redirect_to admin_order_order_details_path
  rescue StandardError
    flash[:danger] = t "create_order_detail_fail"
    redirect_to admin_order_order_details_path
  end

  def destroy_order_detail_transaction
    ActiveRecord::Base.transaction do
      raise StandardError unless @order_detail.destroy

      destroy_update_total_amount
      flash[:success] = t "del_order_pro_suc"
    end
  end

  def update_amount
    ActiveRecord::Base.transaction do
      update_amount_transation
    end
  rescue StandardError
    flash[:danger] = t "update_total_create_order_detail_fail"
    render status: :bad_request
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

  def load_order_detail
    @order_detail = OrderDetail.find_by id: params[:id]
    return if @order_detail

    flash[:danger] = t "order_detail_not_found"
    redirect_to admin_order_order_details_path
  end

  def load_order
    @order = Order.find_by id: params[:order_id]
    return if @order

    flash[:danger] = t "order_not_found"
    redirect_to admin_orders_path
  end

  def access_denied
    flash[:danger] = t("access_denied")
    redirect_to admin_orders_path
  end

  def create_order_detail_transaction
    ActiveRecord::Base.transaction do
      update_product_stock params[:order_detail][:product_id], -1

      raise StandardError unless @order_detail.save

      total_amount = @order_detail.order.total_amount + @order_detail.amount
      raise StandardError unless
      @order_detail.order.update(total_amount: total_amount)

      respond_to :js
    end
  end

  def update_product_stock product_id, operation
    raise StandardError unless product = Product.find_by(id: product_id)

    current_stock = product.stock
    raise StandardError unless product.update(stock: current_stock + operation)
    raise StandardError if product.stock.negative?
  end

  def destroy_update_total_amount
    total_amount = @order_detail.order.total_amount - @order_detail.amount
    operation_for_destroy = @order_detail.quantily
    update_product_stock @order_detail.product_id, operation_for_destroy
    return if @order_detail.order.update(total_amount: total_amount)

    flash[:danger] = t "update_total_create_order_detail_fail"
    redirect_to admin_order_order_details_path
  end

  def update_amount_transation
    set_up_stuff
    raise StandardError unless
    @order_detail.update(quantily: params[:quantily].to_i, amount: @new_amount)

    @new_total_amount += @order_detail.amount
    raise StandardError unless
    @order_detail.order.update(total_amount: @new_total_amount)

    render json: {amount: @new_amount, total_amount: @new_total_amount}
  end

  def set_up_stuff
    @new_amount = @order_detail.price * params[:quantily].to_i
    @new_total_amount = @order_detail.order.total_amount - @order_detail.amount
    @my_opera = @order_detail.quantily > params[:quantily].to_i ? 1 : -1
    update_product_stock @order_detail.product_id, @my_opera
  end
end
