class Subjects::ReplicateController < ApplicationController

	# PUBLIC METHODS
	# ============================================================
	# POST
	# ------------------------------------------------------------
	def create
		@original = Character.find(params[:id]).decorate

		unless @original.cloneable?(current_user)
			redirect_to @original
		else
			@character = @original.replicate(current_user)
			@character.save
			render 'subjects/clones/show'
		end
	end

end
