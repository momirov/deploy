class CreateStages < ActiveRecord::Migration
  def change
    create_table :stages do |t|
      t.references :project
      t.string :title
      t.string :deploy_cmd
      t.string :current_version_cmd
      t.string :next_version_cmd

      t.timestamps
    end
    add_index :stages, :project_id
  end
end
