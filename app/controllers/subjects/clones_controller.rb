class Subjects::ClonesController < ApplicationController

	# FILTERS
	# ------------------------------------------------------------
	before_action :require_user

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# GET
	# ............................................................
	def show
	end

	def edit
		set_associations
		@replication.clone = @clone
	end

	# POST
	# ............................................................
	def create
		@original  = Character.find(params[:id])
		@character = @original.replicate(current_user)

		@character.save
		render 'show'
	end

	# PATCH/PUT
	# ............................................................
	def update
		@replication = Replication.new(replication_params)

		if @replication.save
			redirect_to @replication.clone
		else
			set_associations
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

	def require_user
		unless user_signed_in?
			@character = Character.find(params[:id])
			redirect_to @character
		end
	end

	def set_associations
		@clone       = Character.find(params[:id])
		@replication = Replication.new
		@characters  = Character.not_among([@clone.name])
	end

end
