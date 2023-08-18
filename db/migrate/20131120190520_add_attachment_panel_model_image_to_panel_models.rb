class AddAttachmentPanelModelImageToPanelModels < ActiveRecord::Migration
  def self.up
    change_table :panel_models do |t|
      t.attachment :panel_model_image
    end
  end

  def self.down
    drop_attached_file :panel_models, :panel_model_image
  end
end
