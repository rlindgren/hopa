class Computer < ActiveRecord::Base
  attr_accessible :losses, :ties, :wins, :game_id, :total_games
  has_many :games


end
