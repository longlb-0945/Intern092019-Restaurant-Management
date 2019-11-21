class Admin::OrderDetailsController < AdminController
  before_action :load_order_detail, only: %i(update_amount destroy)
  before_action :load_order, only: %i(index create destroy update_amount)
  load_and_authorize_resource :order_detail

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
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = t "create_order_detail_fail"
    redirect_to admin_order_order_details_path
  end

  def destroy
    ActiveRecord::Base.transaction do
      destroy_order_detail_transaction
    end

    flash[:success] = t "del_order_pro_suc"
    redirect_to admin_order_order_details_path
  rescue ActiveRecord::RecordNotFound, ActiveRecord::RecordInvalid
    flash[:danger] = t "del_order_pro_fail"
    redirect_to admin_order_order_details_path
  end

  def update_amount
    ActiveRecord::Base.transaction do
      update_amount_transation
    end
  rescue ActiveRecord::RecordNotFound, ActiveRecord::RecordInvalid
    flash[:danger] = t "update_total_create_order_detail_fail"
    flash.keep[:danger]
    respond_to do |format|
      format.js do
        render js: "window.location='#{admin_order_order_details_path(@order)}'"
      end
    end
  end

  private
  def order_detail_params
    price = load_product_price
    params.require(:order_detail).permit(OrderDetail::ORDER_DETAIL_PARAMS)
          .merge(order_id: params[:order_id], price: price, amount: price)
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
      @order_detail.save!
      total_amount = @order.total_amount + @order_detail.amount
      @order.update!(total_amount: total_amount)
      respond_to :js
    end
  end

  def update_product_stock product_id, operation
    raise ActiveRecord::RecordNotFound unless product = Product
                                              .find_by(id: product_id)

    current_stock = product.stock

    product.update!(stock: current_stock + operation)
  end

  def destroy_order_detail_transaction
    total_amount = @order.total_amount - @order_detail.amount
    update_product_stock @order_detail.product_id, @order_detail.quantily
    @order.update!(total_amount: total_amount)
    @order_detail.destroy!
  end

  def update_amount_transation
    set_up_stuff
    @order_detail.update!(quantily: params[:quantily].to_i, amount: @new_amount)
    @new_total_amount += @order_detail.amount
    @order.update!(total_amount: @new_total_amount)
    render json: {amount: @new_amount, total_amount: @new_total_amount}
  end

  def set_up_stuff
    @new_amount = @order_detail.price * params[:quantily].to_i
    @new_total_amount = @order.total_amount - @order_detail.amount
    @my_opera = @order_detail.quantily - params[:quantily].to_i
    update_product_stock @order_detail.product_id, @my_opera
  end
end
