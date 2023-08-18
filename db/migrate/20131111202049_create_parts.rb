class CreateParts < ActiveRecord::Migration
  def change
    create_table :parts do |t|
      t.integer :part_type_id
      t.integer :panel_id
      t.integer :length
      t.integer :width
      t.integer :height
      t.integer :count

      t.timestamps
    end
  end
end
