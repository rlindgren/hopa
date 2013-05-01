class GameController < ApplicationController

	def live
		id = params[:id]
		@game = Game.find(params[:id])

	end

end