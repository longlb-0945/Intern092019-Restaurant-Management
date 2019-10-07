class CreatePictures < ActiveRecord::Migration[6.0]
  def change
    create_table :pictures do |t|
      t.string :storage
      t.references :target, polymorphic: true
      
      t.timestamps
    end
  end
end
