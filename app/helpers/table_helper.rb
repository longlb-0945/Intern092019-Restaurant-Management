module TableHelper
  def check_table_status table
    case table.status
    when "available"
      "btn-default"
    when "occupied"
      "btn-warning"
    else
      "btn-secondary"
    end
  end

  def status_mapping
    Table.statuses.keys.map{|w| [w.humanize, w]}
  end

  def table_sort_list
    Table::ORDER_SORT_HASH.to_a
  end
end
