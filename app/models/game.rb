class Game < ActiveRecord::Base
  attr_accessible :comp_wins, :player_wins, :ties, :played_on, :leader_id
  has_many :matches, :dependent => :destroy
  belongs_to :leader
  belongs_to :computer

  def total_score
  	((player_wins/measurable_total.to_f) * 100).round(2)
  end

  def total_matches
  	matches.size
  end

  def final_score
  	(total_matches/total_score) * 100
  end

  def measurable_total
  	player_wins + comp_wins
  end

  def percent_won
  	measurable_total > 0 ? total_score : 0.0
  end


end
