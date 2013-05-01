class BaseController < ApplicationController

	def rpsls
		if !session[:game]
			session[:game] = Game.create!(:comp_wins => 0, :player_wins => 0, :ties => 0, :played_on => Time.now)
			@new_game_message = "<< Pick a strategy"
		end
#		@leaders = Leaders.all
		@current_game = session[:game]
		if @player_move = players_guess
			@comp_move = rand(5)
			match = Match.create!(:comp_move => @comp_move, :player_move => @player_move, :game_id => @current_game.id)
			if players_guess < 5
				@winner, @status, @current_game = Match.winner_and_status(@comp_move, @player_move, @current_game)
				@comp_wins = @current_game.comp_wins
				@player_wins = @current_game.player_wins
				@ties = @current_game.ties
				@total = @current_game.ties + @current_game.comp_wins + @current_game.player_wins
				countable_total = @comp_wins + @player_wins
				@percent_won = countable_total > 0 ? ((@player_wins/countable_total.to_f) * 100).round(2) : 0.0
			elsif players_guess == 5
				flash[:warning] = "Invalid strategy."
				redirect_to rpsls_path
			end
		else
			@new_game_message = "<< Pick a strategy"
			@comp_wins = @current_game.comp_wins
			@player_wins = @current_game.player_wins
			@total = @current_game.ties + @current_game.comp_wins + @current_game.player_wins
			@percent_won = (@comp_wins + @player_wins) > 0 ? ((@player_wins/(@comp_wins + @player_wins).to_f) * 100).round(2) : 0.0
		end
	end

	def reset_game
		game = Game.find(session[:game])
		set_leader(game)
		session[:game] = nil
		flash[:notice] = 'Session has been reset'
		redirect_to rpsls_path
	end

	# def leaderboard
	# 	@leaders = Leaders.all(:order => 'score')
	# end

	private

	def strategies
		['rock','Spock','paper','lizard','scissors']
	end

	def set_leader(game)
		score = game.total_score
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
			%w(0 1 2 3 4).include?(params[:player_move]) ? params[:player_move].to_i : 5
	  else
	  	nil
	  end
	end

end
