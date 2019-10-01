class CreateTables < ActiveRecord::Migration[6.0]
  def change
    create_table :tables do |t|
      t.integer :table_number
      t.integer :max_size
      t.integer :status, default: 0
      
      t.timestamps
    end
  end
end
