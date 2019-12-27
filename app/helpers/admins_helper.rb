module AdminsHelper
  def order_count
    Order.count
  end

  def total_revenue
    Order.sum :total_amount
  end

  def guest_count
    User.guest.size
  end

  def uniq_visitors
    Order.select(:customer_id).distinct.size
  end

  def count_product_by_category
    Category.select(:id, :name).map do |c|
      [c.name, c.products.count]
    end
  end

  def cate_rand_color
    Settings.cate_dash.sample
  end

  def latest_members
    User.latest_members.created_at_desc
  end

  def latest_orders
    Order.latest_orders.order_by "created_at", "DESC"
  end

  def count_pending_orders
    Order.pending.size
  end

  def report_to_a reports
    a_reports = []
    reports.map{ |i| a_reports << i }
    byebug
    return a_reports
  end

  def get_date_data
    if @report_date
      @report_date.to_date.strftime("%d/%m/%Y")
    elsif @report_month
      @report_month.to_date.strftime("%m/%Y")
    end
  end
end
