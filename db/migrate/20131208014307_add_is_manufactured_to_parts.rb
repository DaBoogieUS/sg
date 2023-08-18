class AddIsManufacturedToParts < ActiveRecord::Migration
  def change
    add_column :parts, :is_manufactured, :boolean
  end
end
