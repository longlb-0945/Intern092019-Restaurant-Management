module OrdersHelper
  def check_order_status order
    return "status-" + order.status if order
  end
end
