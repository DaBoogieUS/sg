class AddCutSpacingToMaterials < ActiveRecord::Migration
  def change
    add_column :materials, :cut_spacing, :decimal
  end
end
