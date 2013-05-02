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

	def played
		time_ago_in_words(self.played_on).sub(/about/,"").sub(/minutes/,"mins").sub(/minute/,"min") + " ago"
	end

end