class AddAttachmentPartTypeImageToPartTypes < ActiveRecord::Migration
  def self.up
    change_table :part_types do |t|
      t.attachment :part_type_image
    end
  end

  def self.down
    drop_attached_file :part_types, :part_type_image
  end
end
