class AddLengthToNests < ActiveRecord::Migration
  def change
    add_column :nests, :length, :decimal
  end
end
