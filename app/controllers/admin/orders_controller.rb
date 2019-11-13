class Admin::OrdersController < AdminController
  before_action :guest_not_allow
  before_action :load_order, except: %i(index new create search sort)
  before_action :not_accepted, only: %i(update)
  include OrdersHelper

  def index
    @orders = Order.page(params[:page]).per Settings.pagenate_orders
  end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params.merge(staff_id: current_user.id))
    if @order.save
      flash[:success] = t "order_create_suc"
      redirect_to admin_orders_path
    else
      flash.now[:danger] = t "order_create_fail"
      render :new
    end
  end

  def edit; end

  def update
    if @order.update order_params
      flash[:success] = t "order_update_suc"
      redirect_to edit_admin_order_path(@order)
    else
      flash.now[:danger] = t "order_update_fail"
      render :edit
    end
  end

  def search
    @orders = Order.search(params[:search])
                   .page(params[:page]).per Settings.pagenate_orders
    if @orders.empty?
      flash.now[:danger] =
        I18n.t("no_result_found_order",
               search_text: params[:search])
    else
      search_flash_success
    end
    render :index
  end

  def sort
    if ORDER_SORT_HASH.keys.include? params[:sort].to_sym
      send_sort_params
      render :index
    else
      flash[:danger] = t "sort_param_fail"
      redirect_to admin_orders_path
    end
  end

  def order_update_table
    update_table_setup
    if @order.update(update_table_params)
      flash[:success] = t "order_update_suc"
    else
      flash[:danger] = t "order_update_fail"
    end
    redirect_to edit_admin_order_path(@order)
  end

  def order_status_change
    @order.update! status: params[:status_update].to_i

    @order.update!(staff_id: current_user.id) if @order.accepted?
    update_order_status if @order.cancel? || @order.paid?
    respond_to :js
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = t "cancel_order_fail"
    redirect_to edit_admin_order_path(@order)
  end

  private
  def order_params
    params.require(:order).permit Order::ORDER_PARAMS
  end

  def load_order
    @order = Order.find_by id: params[:id]
    return if @order

    flash[:danger] = t "order_not_found"
    redirect_to admin_orders_path
  end

  def update_order_status
    ActiveRecord::Base.transaction do
      @order.table_to_available

      if @order.cancel?
        @order.order_details.each(&:update_product_stock_after_cancel)
        OrderDetail.where(order_id: @order.id).destroy_all
      end

      OrderTable.where(order_id: @order.id).destroy_all
    end
  end

  def not_accepted
    return if @order.accepted?

    flash[:danger] = t "order_not_accepted"
    redirect_to admin_orders_path
  end

  def search_flash_success
    flash.now[:success] =
      I18n.t("search_with_result_order",
             search_text: params[:search], count: @orders.size)
  end

  def update_table_setup
    @remove_ids = @order.table_ids
    @create_ids = []
    return unless params[:table_ids]

    @remove_ids = @order.table_ids
                        .reject{|id| params[:table_ids].include?(id.to_s)}
    @create_ids = params[:table_ids]
                  .reject{|id| @order.table_ids.include?(id.to_i)}.map(&:to_i)
  end

  def update_table_params
    update_table_setup
    tables_attributes = @remove_ids.map{|id| {id: id, status: 0}}
    order_tables_attributes = @create_ids.map{|id| {table_id: id}}
    @remove_ids.each do |id|
      order_table_id = @order.order_tables
                             .select(:id).where(table_id: id).take.id
      order_tables_attributes.push(id: order_table_id, _destroy: true)
    end
    {tables_attributes: tables_attributes,
     order_tables_attributes: order_tables_attributes}
  end

  def send_sort_params
    arr = params[:sort].split("_")
    order_key = arr.size == 2 ? arr[0] : "#{arr[0]}_#{arr[1]}"
    @orders = Order.order_by(order_key, arr.last).page(params[:page])
                   .per Settings.pagenate_products
  end
end
