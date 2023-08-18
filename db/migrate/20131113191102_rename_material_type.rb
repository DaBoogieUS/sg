class RenameMaterialType < ActiveRecord::Migration
  def change
    rename_column :materials, :type, :material_type
  end
end
