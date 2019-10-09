module TableHelper
  def check_table_status table
    if table.available?
      "btn-success"
    elsif table.occupied?
      "btn-info"
    elsif table.disable?
      "btn-default"
    end
  end

  def status_mapping
    Table.statuses.keys.map{|w| [w.humanize, w]}
  end
end
