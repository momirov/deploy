class RenameRunTimeToCompletedAt < ActiveRecord::Migration
   def up
    change_table :deployments do |t|
      t.remove :run_time
      t.timestamp :completed_at
    end
  end

  def down
    change_table :deployments do |t|
      t.integer :run_time
      t.remove :completed_at
    end
  end
end
