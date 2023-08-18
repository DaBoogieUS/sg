class ChangeIntegersToDecimals < ActiveRecord::Migration
  def change
    change_column :materials, :width, :decimal
    change_column :materials, :height, :decimal
    change_column :materials, :length, :decimal

    change_column :nest_objects, :x, :decimal
    change_column :nest_objects, :y, :decimal

    change_column :parts, :length, :decimal
    change_column :parts, :width, :decimal
    change_column :parts, :height, :decimal

    change_column :panels, :width, :decimal
    change_column :panels, :height, :decimal
    change_column :panels, :door_width, :decimal
    change_column :panels, :door_height, :decimal
    change_column :panels, :door_inset_left, :decimal
  end
end
