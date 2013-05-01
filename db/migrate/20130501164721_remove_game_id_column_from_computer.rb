class RemoveGameIdColumnFromComputer < ActiveRecord::Migration
  def up
    remove_column :computers, :game_id
  end

  def down
    add_column :computers, :game_id, :integer
  end
end
