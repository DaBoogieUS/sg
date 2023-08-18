class CreatePartTypes < ActiveRecord::Migration
  def change
    create_table :part_types do |t|
      t.integer :material_id
      t.string :name
      t.text :description
      t.string :image
      t.integer :version
      t.boolean :nestable

      t.timestamps
    end
  end
end
