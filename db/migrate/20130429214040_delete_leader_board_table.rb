class DeleteLeaderBoardTable < ActiveRecord::Migration
  def change
  	drop_table 'leaderboard'
  end
end
