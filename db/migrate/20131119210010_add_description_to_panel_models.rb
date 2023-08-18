class AddDescriptionToPanelModels < ActiveRecord::Migration
  def change
    add_column :panel_models, :description, :text
  end
end
