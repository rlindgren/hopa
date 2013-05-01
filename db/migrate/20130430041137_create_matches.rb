class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :comp_move
      t.integer :player_move

      t.timestamps
    end
  end
end
