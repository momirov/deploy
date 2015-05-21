class RenameNextVersionToBranch < ActiveRecord::Migration
  def change
    change_table :stages do |t|
      t.remove :next_version_cmd
      t.string :branch
    end
  end
end
