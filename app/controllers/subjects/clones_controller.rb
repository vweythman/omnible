class Subjects::ClonesController < ApplicationController

	# PUBLIC METHODS
	# ============================================================
	# GET
	# ------------------------------------------------------------
	def new
		clone_character
		can_be_a_clone?

		@replication       = Replication.new
		@replication.clone = @clone
	end

	# POST
	# ------------------------------------------------------------
	def create
		clone_character
		original_character
		
		if connectable?
			@replication = Replication.new(replication_params)

			if @replication.save
				redirect_to(@replication.clone)
			else
				render action: 'edit'
			end
		else
			redirect_to @clone
		end
	end

	# DELETE
	# ------------------------------------------------------------
	def destroy
		clone_character

		if @clone.decloneable?(current_user)
			@clone.declone
			@clone.save
		end

		redirect_to @clone
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
	def character_selection(id)
		@found_character = Character.find(id).decorate
	end

	# SET
	# ------------------------------------------------------------
	def clone_character
		@clone = character_selection(params[:id])
	end

	def original_character
		@original = character_selection(params[:replication][:original_id])
	end

	# PERMIT
	# ------------------------------------------------------------
	def connectable?
		@connectable = @original.cloneable?(current_user) && @clone.can_be_a_clone?(current_user)
	end

	def can_be_a_clone?
		unless @clone.can_be_a_clone?(current_user)
			redirect_to(@clone)
		end
	end

end
