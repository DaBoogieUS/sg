class CreatePhases < ActiveRecord::Migration
  def change
    create_table :phases do |t|
      t.integer :job_id
      t.string :name
      t.date :manufacture_start
      t.date :manufacture_end
      t.date :install_start
      t.date :install_end

      t.timestamps
    end
  end
end
