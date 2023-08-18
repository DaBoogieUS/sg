class CreatePanelModels < ActiveRecord::Migration
  def change
    create_table :panel_models do |t|
      t.string :name

      t.timestamps
    end
  end
end
