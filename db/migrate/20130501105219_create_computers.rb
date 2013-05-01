class CreateComputers < ActiveRecord::Migration
  def change
    create_table :computers do |t|
      t.integer :wins
      t.integer :losses
      t.integer :ties

      t.timestamps
    end
  end
end
