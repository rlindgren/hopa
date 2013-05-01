class AddLeaderColumnToGames < ActiveRecord::Migration
  def change
    add_column :games, :leader_id, :integer
  end
end
