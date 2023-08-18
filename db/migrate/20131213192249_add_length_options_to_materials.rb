class AddLengthOptionsToMaterials < ActiveRecord::Migration
  def change
    add_column :materials, :length_options, :text
  end
end
