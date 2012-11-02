class AddRevisionToDeployments < ActiveRecord::Migration
  def up
    change_table :deployments do |t|
      t.string :old_revision
      t.string :new_revision
    end
  end

  def down
    change_table :deployments do |t|
      t.remove :old_revision
      t.remove :new_revision
    end
  end
end
