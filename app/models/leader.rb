class Leader < ActiveRecord::Base
	attr_accessible :name, :score, :played_on, :game_id
	validates :name, :length => { :maximum => 3 }
	has_one :game
	has_many :matches

	def self.get_highscores
		highscores = []
		highscorers = all(:order => "score DESC", :limit => 10)
		highscorers.each { |hs| highscores << hs.score }
		highscores
	end

	def num_matches
		game = Game.find(self.id)
		game.matches.size
	end

end

