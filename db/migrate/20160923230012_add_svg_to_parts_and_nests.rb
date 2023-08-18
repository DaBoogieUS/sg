class AddSvgToPartsAndNests < ActiveRecord::Migration
  def change
    add_column :parts, :svg, :text
    add_column :nests, :svg, :text
  end
end
