#!/bin/env ruby
# encoding: utf-8

class BaseController < ApplicationController

	def rpsls
		debugger
		@player_name = session[:name] || "You"
		@new_game_message, @current_game, flash[:notice] = new_game_time?
		@name_msg = stored_name
		@leaders = Leader.get_highscorers
		@strategies = Match.strategies
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
		if session[:game]
			begin
				game = Game.find(session[:game])
				Leader.check_for_highscore_and_create_new_leader(game)
				session[:game] = nil
				flash_and_redirect
			rescue
				session[:game] = nil
				flash_and_redirect
			end
		else
			flash_and_redirect
		end
	end

	def leaderboard
		if flash[:leaderboard]
			flash[:leaderboard] = false
			redirect_to rpsls_path and return
		else
			flash[:leaderboard] = true
			redirect_to rpsls_path and return
		end
	end

	def name_input
		if params[:name].length > 3
			flash[:notice] = 'max 3, baby.'
			redirect_to rpsls_path
		else
			session[:name] = params[:name]
			flash[:notice] = "#{name_confirmation_messages}" # method produces string
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
		begin
			game = Game.find(session[:game])
			[nil, game]
		rescue
			game = Game.create!(:comp_wins => 0, :player_wins => 0, :ties => 0, :played_on => Time.now)
			session[:game] = game.id
			["<< Pick a strategy", game, "\"new game\" ends the current game, posts your score, and starts a new one! A new game has begun......"]
		end
	end

	def stored_name
		if !session[:name] then "<< INITIALS!" else nil end
	end

	def player_move
		if (p = params[:player])
			if Match.strategies.include?(p)
			 	Match.strategies.index(p)
			else
			 	5
			end
		else
			nil
		end
	end

	def flash_and_redirect
		flash[:notice] = 'New game started! Good luck! ;)'
		redirect_to rpsls_path
	end

	def name_confirmation_messages
		name = session[:name]
		sayings = [
			"#{name}! you so cute!! 囧",
			"'#{name}'... really? hehe",
			"'#{name}'... OK, if you say so.",
			"I'm guessing that's a family name? :P",
			"Alright, alright! - I like it.",
			"That is possibly the worst combination of letters imaginable. ;P",
			"Never has a name more gracefully animated the tongue than that.",
			"I see what you've done there, you dog!"
		]
		sayings[rand(sayings.length)]
	end

end
