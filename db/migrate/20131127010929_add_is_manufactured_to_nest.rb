class AddIsManufacturedToNest < ActiveRecord::Migration
  def change
    add_column :nests, :is_manufactured, :boolean
  end
end
