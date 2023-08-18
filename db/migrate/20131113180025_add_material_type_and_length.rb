class AddMaterialTypeAndLength < ActiveRecord::Migration
  def change
    add_column :materials, :type, :string
    add_column :materials, :length, :integer
  end
end
