class AddRotatedToNestObjects < ActiveRecord::Migration
  def change
    add_column :nest_objects, :rotated, :boolean
  end
end
