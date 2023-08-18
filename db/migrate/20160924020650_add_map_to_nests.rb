class AddMapToNests < ActiveRecord::Migration
  def change
    add_column :nests, :map_svg, :text
  end
end
