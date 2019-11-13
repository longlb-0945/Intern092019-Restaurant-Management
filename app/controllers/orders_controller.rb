class OrdersController < ApplicationController
  before_action :authenticate_user!

  def new
    @order = Order.new
  end

  def create
    @order = Order.new assign_params
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
    params.require(:order).permit :name, :phone, :address, :person_number
  end

  def assign_params
    params_key = current_user.guest? ? :customer_id : :staff_id
    order_params.merge(params_key => current_user.id)
  end
end
