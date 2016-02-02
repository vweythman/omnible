class Subjects::ClonesController < ApplicationController

	# FILTERS
	# ============================================================
	before_action :original_character, only: [:create]
	before_action :clone_character,    only: [:edit, :update]
	before_action :can_create?

	# PUBLIC METHODS
	# ============================================================
	# GET
	# ------------------------------------------------------------
	def edit
		@replication       = Replication.new
		@replication.clone = @clone
	end

	# POST
	# ------------------------------------------------------------
	def create
		@character = @original.replicate(current_user)
		@character.save
		render 'show'
	end

	# PATCH/PUT
	# ------------------------------------------------------------
	def update
		@replication = Replication.new(replication_params)

		if @replication.save
			redirect_to @replication.clone
		else
			render action: 'edit'
		end
	end
	
	# PRIVATE METHODS
	# ============================================================
	private

	# CLEAN
	# ------------------------------------------------------------
	def replication_params
		params.require(:replication).permit(:original_id, :clone_id)
	end

	# FIND
	# ------------------------------------------------------------
	def character_selection
		@found_character = Character.find(params[:id]).decorate
	end

	# SET
	# ------------------------------------------------------------
	def clone_character
		@clone = character_selection
	end

	def original_character
		@original = character_selection
	end

	# PERMIT
	# ------------------------------------------------------------
	def can_create?
		unless user_signed_in?
			redirect_to @found_character
		end
	end

end
