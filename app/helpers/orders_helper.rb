module OrdersHelper
  def check_order_status order
    return "status-" + order.status if order
  end

  def load_order_table _order
    Table.usefull.reduce([]){|a, e| a << array_table_item(e)}
  end

  def array_table_item table
    ["#{I18n.t('number_table')} - #{table.table_number} |
      #{I18n.t('table_size')} - #{table.max_size}", table.id]
  end

  def load_order_preselected order
    order.tables.ids
  end
end
