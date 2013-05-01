class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :comp_wins
      t.integer :player_wins
      t.integer :ties
      t.datetime :played_on
      t.timestamps
    end
  end
end
