class AddGameIdAndTotalGamesColumnsToComputer < ActiveRecord::Migration
  def change
    add_column :computers, :game_id, :integer
    add_column :computers, :total_games, :integer
  end
end
