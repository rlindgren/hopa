class Match < ActiveRecord::Base
  attr_accessible :comp_move, :player_move, :game_id
  belongs_to :game
  belongs_to :leader

	def winner_and_status(comp, player, game)
		diff = player - comp
		player_move = player
		comp_move = comp
		if diff == 0
			game.ties += 1
			game.save!
			if game.ties < 2
				["Neither wins.", "Looks like a tie!"]
			else
				["Notaone.", "We've tied... again."]
			end
		elsif diff % 5 < 3
			game.player_wins += 1
			game.save!
			["You won...", find_status(comp_move, player_move)]
		else
			game.comp_wins += 1
			game.save!
			["I won!", find_status(comp_move, player_move)]
		end
	end

	def find_status(comp_move, player_move)
		comp_move = self.class.strategies[comp_move]
		player_move = self.class.strategies[player_move]
		statuses.each do |line|
			line_down = line.downcase
			if line_down.include?(comp_move.downcase) && line_down.include?(player_move.downcase)
				return line
			end
		end
	end

	def self.strategies
		['rock','Spock','paper','lizard','scissors']
	end

	def statuses
		[
		"Scissors cut paper",
		"Paper covers rock",
		"Rock crushes lizard",
		"Lizard poisons Spock",
		"Spock melts scissors",
		"Scissors decapitate lizard",
		"Lizard eats paper",
		"Paper disproves Spock",
		"Spock vaporizes rock",
		"Rock breaks scissors"
		]
	end

end
