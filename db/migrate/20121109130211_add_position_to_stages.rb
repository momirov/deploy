class AddPositionToStages < ActiveRecord::Migration
  def up
    change_table :stages do |t|
      t.integer :position
    end
  end

  def down
    change_table :stages do |t|
      t.remove :position
    end
  end
end
