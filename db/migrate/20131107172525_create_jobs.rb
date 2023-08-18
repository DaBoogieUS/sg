class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.integer :client_id
      t.string :name
      t.text :location

      t.timestamps
    end
  end
end
