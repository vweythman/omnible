class Subjects::ClonesController < ApplicationController

	# PUBLIC METHODS
	# ------------------------------------------------------------

	# GET
	# ............................................................
	def show
	end

	def edit
		@clone       = Character.find(params[:id])
		@replication = Replication.new
		@characters  = Character.not_among([@clone.name])

		@replication.clone = @clone
	end

	# POST
	# ............................................................
	def create
		@original  = Character.find(params[:id])
		@character = @original.replicate(current_user)
		render 'show'
	end

	# PATCH/PUT
	# ............................................................
	def update
		@replication = Replication.new(replication_params)

		if @replication.save
			redirect_to @replication.clone
		else
			@clone       = Character.find(params[:id])
			@replication = Replication.new
			@characters  = Character.not_among([@clone.name])
			render action: 'edit'
		end
	end
	
	# PRIVATE METHODS
	# ------------------------------------------------------------
	private

	# define strong parameters
	def replication_params
		params.require(:replication).permit(:original_id, :clone_id)
	end

end
