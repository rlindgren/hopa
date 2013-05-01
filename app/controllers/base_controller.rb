class BaseController < ApplicationController
	before_filter :new_game, :only => :rpsls

	def rpsls
		@name_msg = stored_name
		@current_game = Game.find(session[:game])
		@leaders = Leader.all(:order => "score DESC", :limit => 10)
		@strategies = Match.strategies
		if player_move
			comp_move = rand(5)
			@current_match = Match.create!(:comp_move => comp_move, :player_move => player_move, :game_id => @current_game.id)
			if player_move < 5
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

	def name_input
		if params[:name].length > 3
			flash[:notice] = 'max 3, baby.'
			redirect_to rpsls_path
		else
			session[:name] = params[:name]
			flash[:notice] = "#{name_confirmation_messages}"
			redirect_to rpsls_path
		end
	end

	private

	def set_leader(game)
		score = game.final_score
		highscores = Leader.get_highscores
		if score > highscores.min.to_f || highscores.size < 10
			validate_name_input
			name = session[:name]
			Leader.create!(:name => name, :score => score, :played_on => game.played_on, :game_id => game.id)
		end
	end

	def player_move
		if (p = params[:player_move])
			Match.strategies.include?(p) ? Match.strategies.index(p) : 5
	  else
	  	nil
	  end
	end

	def new_game
		if !session[:game]
			game = Game.create!(:comp_wins => 0, 
													:player_wins => 0, 
													:ties => 0, 
													:played_on => Time.now)
			session[:game] = game.id
			@new_game_message = "<< Pick a strategy"
			@new_game_message
		end
	end

	def validate_name_input
		if !session[:name]
			flash[:notice] = "You have brought glory unto your name! Now I need it to put on my awesome wall! Submit your initals..."
			redirect_to rpsls_path
		end
	end

	def name_confirmation_messages
		name = session[:name]
		[
			"#{name}, so cute!",
			"#{name}... really?",
			"#{name}. OK, if you say so.",
			"I'm guessing '#{name}' is a family name, huh?",
			"'#{name}' - I like it!",
			"'#{name}' is probably the worst combination of letters imaginable.",
			"Never has a name more gracefully animated the tongue than '#{name}'!",
			"I see what you've done there, you dog!"
		][rand(8)]
	end

	def stored_name
		session[:name] ? nil : "input your initals now in case you get lucky!"
	end

end
