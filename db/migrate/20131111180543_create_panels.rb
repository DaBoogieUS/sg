class CreatePanels < ActiveRecord::Migration
  def change
    create_table :panels do |t|
      t.integer :structure_id
      t.integer :panel_model_id
      t.boolean :is_manufactured
      t.boolean :is_assembled
      t.integer :side_position
      t.integer :width
      t.integer :height
      t.boolean :deflector
      t.boolean :buried
      t.integer :door_width
      t.integer :door_height
      t.integer :door_inset_left

      t.timestamps
    end
  end
end
