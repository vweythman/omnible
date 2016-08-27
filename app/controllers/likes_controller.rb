class LikesController < ApplicationController

	# CALLBACKS
	# ============================================================
	before_action :signed_restriction

	# MODULES
	# ============================================================
	include ReaderResponse

	# PUBLIC METHODS
	# ============================================================
	# POST
	# ------------------------------------------------------------
	def create
		work
		opinion

		if @opinion.nil?
			WorkOpinion.create(user_id: current_user.id, work_id: @work.id, value: 1)
		else
			@opinion.make_liked
			@opinion.save
			response_format
		end
	end

	# DELETE
	# ------------------------------------------------------------
	def destroy
		work
		opinion

		if !@opinion.nil? && @opinion.is_a_like?
			@opinion.destroy
			response_format
		end
	end

end
