class CreateNestObjects < ActiveRecord::Migration
  def change
    create_table :nest_objects do |t|
      t.integer :part_id
      t.integer :nest_id
      t.integer :x
      t.integer :y

      t.timestamps
    end
  end
end
