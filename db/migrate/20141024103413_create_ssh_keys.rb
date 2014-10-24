class CreateSshKeys < ActiveRecord::Migration
  def change
    create_table :ssh_keys do |t|
      t.text :private_key
      t.text :public_key
      t.string :comment
      t.string :passphrase
      t.belongs_to :project

      t.timestamps
    end
  end
end
