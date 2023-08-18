class CreateManufacturingJobs < ActiveRecord::Migration
  def change
    create_table :manufacturing_jobs do |t|
      t.integer :phase_id
      t.string :name
      t.date :date

      t.timestamps
    end
  end
end
