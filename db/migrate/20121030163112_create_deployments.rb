class CreateDeployments < ActiveRecord::Migration
  def change
    create_table :deployments do |t|
      t.references :stage
      t.references :project
      t.string :user
      t.text :log
      t.boolean :success
      t.integer :run_time

      t.timestamps
    end
    add_index :deployments, :stage_id
    add_index :deployments, :project_id
  end
end
