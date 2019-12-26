class CreateRates < ActiveRecord::Migration[6.0]
  def change
    create_table :rates do |t|
      t.references :user
      t.references :product
      t.text :comment
      t.integer :point
      
      t.timestamps
    end
  end
end
