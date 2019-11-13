module OrdersHelper
  ORDER_SORT_HASH = {status_asc: I18n.t("order_status_asc"),
                     status_desc: I18n.t("order_status_desc"),
                     person_number_asc:
    I18n.t("order_person_number_asc"),
                     person_number_desc:
    I18n.t("order_person_number_desc"),
                     total_amount_asc: I18n.t("order_total_amount_asc"),
                     total_amount_desc:
     I18n.t("order_total_amount_desc")}.freeze

  def check_order_status order
    "order-status-#{order.status}"
  end

  def load_order_table order
    result = []
    Table.usefull.reduce(result){|a, e| a << array_table_item(e)}
    order.tables.reduce(result){|a, e| a << array_table_item(e)}
  end

  def array_table_item table
    ["#{I18n.t('number_table')} - #{table.table_number} |
      #{I18n.t('table_size')} - #{table.max_size}", table.id]
  end

  def load_order_preselected order
    order.tables.ids
  end

  def order_sort_list
    ORDER_SORT_HASH.map{|key, value| [value, key]}
  end
end
