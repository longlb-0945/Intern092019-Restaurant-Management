class NotificationsController < ApplicationController
  def index
    if current_user.notifications.update(status: :read)
      flash[:success] = "Mark notifications success!"
      redirect_to user_orders_path(current_user)
    else
      flash[:danger] = "Mark notification failed!"
      redirect_to root_path
    end
  end

  def update
    @notification = Notification.find_by(id: params[:id])
    if @notification&.read!
      redirect_to user_orders_path(current_user)
    else
      flash[:danger] = "Not found notifications!"
      redirect_to root_path
    end
  end
end
