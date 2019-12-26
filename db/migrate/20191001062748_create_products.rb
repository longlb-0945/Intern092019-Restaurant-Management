class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :name
      t.text :short_description
      t.references :category
      t.integer :price
      t.integer :status, default: 0
      t.integer :stock
      t.float :total_rate, default: 0

      t.timestamps
    end
  end
end
