#!/bin/env ruby
# encoding: utf-8

class BaseController < ApplicationController

	def rpsls
		@new_game_message = new_game_time?
		@current_game = Game.find(session[:game])

		@leaders = Leader.all(:order => "score DESC", :limit => 10)
		@strategies = Match.strategies
		@name_msg = stored_name

		if player_move
			comp_move = rand(5)
			@current_match = Match.create!(:comp_move => comp_move, :player_move => player_move, :game_id => @current_game.id)
			if player_move < 5
				@winner, @status = @current_match.winner_and_status(comp_move, player_move, @current_game)
			else
				flash[:warning] = "Invalid strategy."
				redirect_to rpsls_path
			end
		else
			@new_game_message = "<< Pick a strategy"
		end
	end

	def new_game
		game = Game.find(session[:game])
		set_leader(game)
		session[:game] = nil
		flash[:notice] = 'Session has been reset'
		redirect_to rpsls_path and return
	end

	def leaderboard
		flash[:leaderboard] = true
		redirect_to rpsls_path
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

	def clear_name
		session[:name] = nil
		flash[:notice] = "Wiped successfully. Choose a new name."
		redirect_to rpsls_path
	end

	private

	def new_game_time?
		if !session[:game]
			game = Game.create!(:comp_wins => 0, 
													:player_wins => 0, 
													:ties => 0, 
													:played_on => Time.now)
			session[:game] = game.id
			new_game_message = "<< Pick a strategy"
			new_game_message
		end
	end

	def stored_name
		if !session[:name] then "input your initals, yo!" else nil end
	end

	def player_move
		(p = params[:player_move]) ? Match.strategies.include?(p) ? Match.strategies.index(p) : 5 : nil
	end

	def set_leader(game)
		score = game.final_score
		highscores = Leader.get_highscores
		if score > highscores.min.to_f || highscores.size < 10
			validate_name_input_and_create_leader(game, score)
		end
	end

	def validate_name_input_and_create_leader(game, score)
		if !session[:name]
			flash[:notice] = "You have brought glory unto your name! Now I need it to put on my awesome wall! Submit your initals..."
			redirect_to rpsls_path
		else
			name = session[:name]
			Leader.create!(:name => name, :score => score, :played_on => game.played_on, :game_id => game.id)
		end
	end

	def name_confirmation_messages
		name = session[:name]
		sayings = [
			"#{name}! so cute!! 囧",
			"#{name}... really? hehe",
			"#{name}. OK, if you say so.",
			"I'm guessing '#{name}' is a family name, huh? :P",
			"'#{name}' - I like it!",
			"'#{name}' is probably the worst combination of letters imaginable. j/k!",
			"Never has a name more gracefully animated the tongue than '#{name}'!",
			"I see what you've done there, you dog!"
		]
		sayings[rand(sayings.length)]
	end

end
