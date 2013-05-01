class Game < ActiveRecord::Base
  attr_accessible :comp_wins, :player_wins, :ties, :played_on
  has_many :matches, :dependent => :destroy

  def total_score
  	self.player_wins/(self.comp_wins + self.player_wins) * 100
  end
end
