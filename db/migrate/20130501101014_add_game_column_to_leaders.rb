class AddGameColumnToLeaders < ActiveRecord::Migration
  def change
    add_column :leaders, :game_id, :integer
  end
end
