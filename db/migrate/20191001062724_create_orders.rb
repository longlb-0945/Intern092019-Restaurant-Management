class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.references :customer
      t.references :staff
      t.string :name
      t.string :phone
      t.string :address
      t.integer :status, default: 0
      t.integer :total_amount

      t.timestamps
    end
  end
end
