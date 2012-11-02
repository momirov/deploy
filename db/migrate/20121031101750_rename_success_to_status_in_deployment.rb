class RenameSuccessToStatusInDeployment < ActiveRecord::Migration
  def up
    change_table :deployments do |t|
      t.remove :success
      t.string :status
    end
  end

  def down
    change_table :deployments do |t|
      t.boolean :success
      t.remove :status
    end
  end
end
