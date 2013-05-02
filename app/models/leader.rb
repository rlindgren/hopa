class Leader < ActiveRecord::Base
	include ActionView::Helpers::DateHelper

	attr_accessible :name, :score, :played_on, :game_id
	has_one :game

	@@dynamic_methods_hash = {'wins' => 'player_wins', 
														'ties' => 'ties', 
														'losses' => 'comp_wins', 
														'num_matches' => 'matches.size'}

	@@dynamic_methods_hash.each_pair do |k,v|
		class_eval <<-RUBY
			def #{k}
				begin
					game = Game.find(self.game_id)
					game.#{v}
				rescue
					0
				end
			end
		RUBY
	end

	def self.get_highscorers
		all(:order => "score DESC", :limit => 20)
	end

	def self.get_highscores
		highscores = []
		highscorers = self.get_highscorers
		highscorers.each { |hs| highscores << hs.score }
		highscores
	end

	def self.check_for_highscore_and_create_new_leader(game, name)
		score = game.final_score
		highscores= get_highscores
		highscores.include?(nil) || highscores.include?('') ? highscore_low = 0.0 : highscore_low = highscores.min.to_f	
		if highscore_low === 0.0 || (score > highscore_low && game.matches.size > 10)
			set_new_leader(game, score, name)
		end
	end

	def self.set_new_leader(game, score, name)
		if name
			create!(:name => name, :score => score, :played_on => game.played_on, :game_id => game.id)
		else
			name = ('A'..'Z').to_a.sample(rand(3)).join
			create!(:name => name, :score => score, :played_on => game.played_on, :game_id => game.id)
		end
	end

	def played
		time_ago_in_words(self.played_on).sub(/about/,"").sub(/minutes/,"mins").sub(/minute/,"min") + " ago"
	end

end