class AddRollbackCommandToStage < ActiveRecord::Migration
  def up
    change_table :stages do |t|
      t.string :rollback_cmd
    end
  end

  def down
    change_table :stages do |t|
      t.remove :rollback_cmd
    end
  end
end
