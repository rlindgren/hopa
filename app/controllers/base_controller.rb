class BaseController < ApplicationController

	def rpsls
		if !session[:game]
			leader = Leader.create(:played_on => Time.now)
			game = Game.create!(:comp_wins => 0, :player_wins => 0, :ties => 0, :played_on => Time.now, :leader_id => leader.id)
			leader.game_id = game.id
			session[:game] = game.id
			@new_game_message = "<< Pick a strategy"
		end
		@leaders = Leader.all(:order => "score DESC", :limit => 10)
		@current_game = Game.find(session[:game])
		@strategies = Match.strategies
		if player_move = players_guess
			comp_move = rand(5)
			@current_match = Match.create!(:comp_move => comp_move, :player_move => player_move, :game_id => @current_game.id)
			if players_guess < 5
				@winner, @status, @current_game = @current_match.winner_and_status(comp_move, player_move, @current_game)
				@total_matches = @current_game.total_matches
				@percent_won = @current_game.percent_won
			else
				flash[:warning] = "Invalid strategy."
				redirect_to rpsls_path
			end
		else
			@new_game_message = "<< Pick a strategy"
			@total_matches = @current_game.total_matches
			@percent_won = @current_game.percent_won
		end
	end

	def reset_game
		game = Game.find(session[:game])
		set_leader(game)
		session[:game] = nil
		flash[:notice] = 'Session has been reset'
		redirect_to rpsls_path
	end

	def leaderboard
		@leaders = Leader.all(:order => 'score')
	end

	private

	def set_leader(game)
		score = game.final_score
		highscores = Leader.get_highscores
		if score > highscores.min.to_f || highscores.size < 10
			name = ('A'..'Z').to_a.sample(3).join.to_s
			Leader.create!(:name => name, :score => score, :played_on => game.played_on)
		else
			true
		end
	end

	def players_guess
		if params[:player_move]
			Match.strategies.include?(params[:player_move]) ? Match.strategies.index(params[:player_move]) : 5
	  else
	  	nil
	  end
	end

end
