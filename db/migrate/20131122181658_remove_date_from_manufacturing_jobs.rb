class RemoveDateFromManufacturingJobs < ActiveRecord::Migration
  def change
    remove_column :manufacturing_jobs, :date, :date
  end
end
