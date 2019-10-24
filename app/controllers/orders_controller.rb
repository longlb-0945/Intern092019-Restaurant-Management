class OrdersController < ApplicationController
  before_action :not_login
  before_action :guest_not_allow, except: %i(new create)
  before_action :load_order, except: %i(index new create)

  def index
    @orders = Order.page(params[:page]).per Settings.pagenate_orders
  end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new order_params
    if @order.save
      flash.now[:success] = t "order_create_suc"
      redirect_to orders_path
    else
      flash.now[:danger] = t "order_create_fail"
      render :new
    end
  end

  def edit; end

  def update
    @order.tables.each(&:available!)
    if @order.update order_params
      update_order_table if params[:order][:table_ids]
      flash[:success] = t "order_update_suc"
      redirect_to orders_path
    else
      flash[:danger] = t "order_update_fail"
      render :edit
    end
  end

  def order_status_change
    @order.update status: params[:do_what].to_i
    respond_to :js
    update_order_status if @order.cancel? || @order.paid?
  rescue StandardError
    flash[:danger] = t "cancel_order_fail"
    redirect_to :index
  end

  private
  def order_params
    params.require(:order).permit Order::ORDER_PARAMS
  end

  def load_order
    @order = Order.find_by id: params[:id]
    return if @order

    flash[:danger] = t "order_not_found"
    redirect_to orders_path
  end

  def update_order_status
    ActiveRecord::Base.transaction do
      @order.tables.each do |table|
        raise StandardError unless table.available!

        OrderTable.where(order_id: @order.id).destroy_all
        OrderDetail.where(order_id: @order.id).destroy_all if @order.cancel?
      end
    end
  end
end
