class CreateManufacturingJobsPartsJoinTable < ActiveRecord::Migration
  def change
    create_table :manufacturing_jobs_parts, id: false do |t|
      t.integer :manufacturing_job_id
      t.integer :part_id
    end
  end
end
