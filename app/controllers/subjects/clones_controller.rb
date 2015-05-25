class Subjects::ClonesController < ApplicationController

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# POST
	# ............................................................
	def create
		find_original
		@character = @original.replicate
		render 'new'
	end

	# GET
	# ............................................................
	def new
	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private

	# find by id
	def find_original
		@original = Character.find(params[:character_id])
	end
end
