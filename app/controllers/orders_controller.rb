class OrdersController < ApplicationController
  before_action :find_user, :correct_user, only: %i(index destroy)
  before_action :check_guest, only: :index
  before_action :find_order, :not_pending, only: :destroy

  def index
    @orders = current_user.customer_orders.page(params[:page])
                          .per Settings.pagenate_orders
  end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new assign_params
    if @order.save
      flash[:success] = t "order_create_suc"
      redirect_to root_path
      new_notification_job "Created", @order.id, @order.customer.id

      CheckOrderTimeJob.set(wait_until: @order.start_time-7*3600).perform_later(@order.id)
    else
      flash[:danger] = t "order_create_fail"
      render :new
    end
  end

  def destroy
    if @order.cancel!
      flash[:success] = t "order_update_suc"
    else
      flash[:danger] = t "order_update_fail"
    end
    redirect_to user_orders_path(@user)
  end

  private
  def order_params
    params.require(:order).permit :name, :phone, :address, :person_number, :start_time
  end

  def assign_params
    params_key = current_user.guest? ? :customer_id : :staff_id
    order_params.merge(params_key => current_user.id)
  end

  def find_user
    return if @user = User.find_by(id: params[:user_id])

    flash[:danger] = t "user_not_found"
    redirect_to root_path
  end

  def correct_user
    redirect_to root_path unless current_user&.admin? || current_user == @user
  end

  def find_order
    return if @order = Order.find_by(id: params[:order_id])

    flash[:danger] = t "order_not_found"
    redirect_to orders_user_path(@user)
  end

  def not_pending
    return if @order.pending?

    flash[:danger] = t "access_denied"
    redirect_to orders_user_path(@user)
  end
end
