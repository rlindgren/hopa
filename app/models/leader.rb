class Leader < ActiveRecord::Base
	attr_accessible :name, :score, :played_on, :game_id
	validates :name, :length => { :maximum => 3 }
	has_one :game
	has_many :matches

	def self.get_highscores
		highscores = []
		highscorers = self.all(:order => "score DESC", :limit => 10)
		highscorers.each { |hs| highscores << hs.score }
		highscores
	end

	def method_missing(*args)

	end

	def wins
		begin
			game = Game.find(self.game_id)
			game.player_wins
		rescue
			0
		end
	end

	def ties
		begin
			game = Game.find(self.game_id)
			game.ties
		rescue
			0
		end
	end

	def losses
		begin
			game = Game.find(self.game_id)
			game.comp_wins
		rescue
			0
		end
	end

	def num_matches
		begin
			game = Game.find(self.game_id)
			game.matches.size
		rescue
			0	
		end
	end

	def num_matches
		begin
			game = Game.find(self.game_id)
			game.matches.size
		rescue
			0	
		end
	end

end

