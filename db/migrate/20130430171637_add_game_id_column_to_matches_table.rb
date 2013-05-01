class AddGameIdColumnToMatchesTable < ActiveRecord::Migration
  def change
    add_column :matches, :game_id, :integer
  end
end
