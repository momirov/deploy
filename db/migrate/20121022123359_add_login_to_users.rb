class AddLoginToUsers < ActiveRecord::Migration
  def change
    add_column :users, :login, :string, :null => false, :default => '', :unique => true
  end
end
