class RemoveLengthFromMaterials < ActiveRecord::Migration
  def change
    remove_column :materials, :length, :length
  end
end
