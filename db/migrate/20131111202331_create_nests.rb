class CreateNests < ActiveRecord::Migration
  def change
    create_table :nests do |t|
      t.integer :nest_run_id

      t.timestamps
    end
  end
end
