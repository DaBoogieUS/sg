class CreateNestRuns < ActiveRecord::Migration
  def change
    create_table :nest_runs do |t|
      t.integer :manufacturing_job_id
      t.integer :material_id

      t.timestamps
    end
  end
end
