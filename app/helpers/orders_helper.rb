module OrdersHelper
  def check_order_status order
    return "status-" + order.status if order
  end

  def load_order_table
    Table.all.map do |ta|
      ["#{I18n.t('number_table')} - #{ta.table_number} |
        #{I18n.t('table_size')} - #{ta.max_size}", ta.id]
    end
  end

  def load_order_preselected order
    order.tables.ids
  end
end
