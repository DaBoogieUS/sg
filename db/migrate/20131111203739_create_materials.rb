class CreateMaterials < ActiveRecord::Migration
  def change
    create_table :materials do |t|
      t.string :name
      t.integer :width
      t.integer :height
      t.integer :count

      t.timestamps
    end
  end
end
