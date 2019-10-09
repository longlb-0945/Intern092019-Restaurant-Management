class CreateOrderTables < ActiveRecord::Migration[6.0]
  def change
    create_table :order_tables do |t|
      t.references :order
      t.references :table
      t.index [:order_id, :table_id], :unique => true

      t.timestamps
    end

  end
end
