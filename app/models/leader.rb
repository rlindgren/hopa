class Leader < ActiveRecord::Base
	attr_accessible :name, :score, :played_on
	validates :name, :presence => true, :length => { :maximum => 3 }
	has_one :game

	def self.get_highscores
		highscores = []
		highscorers = find(:all, :order => 'score', :limit => 10)
		highscorers.each { |hs| highscores << hs.score }
		highscores
	end
end