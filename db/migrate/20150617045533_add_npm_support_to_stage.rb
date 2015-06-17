class AddNpmSupportToStage < ActiveRecord::Migration
  def up
    change_table :stages do |t|
      t.boolean :npm_support
    end
  end

  def down
    change_table :stages do |t|
      t.remove :npm_support
    end
  end
end
