class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.references :user
      t.string :title
      t.string :text
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
