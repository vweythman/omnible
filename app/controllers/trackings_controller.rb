class TrackingsController < ApplicationController

	before_action :signed_restriction

	# PUBLIC METHODS
	# ============================================================
	# POST
	# ------------------------------------------------------------
	def create
		tracked_params
		@to_be_tracked = @tracked_type.classify.constantize.find(@tracked_id)

		unless @to_be_tracked.uploader? current_user
			current_user.track @to_be_tracked

			respond_to do |format|
				format.js { render layout: false }
			end
		end
	end

	# DELETE
	# ------------------------------------------------------------
	def destroy
		tracked_params
		@being_tracked = @tracked_type.classify.constantize.find(@tracked_id)

		if current_user.tracking? @being_tracked
			current_user.untrack(@being_tracked)

			respond_to do |format|
				format.js { render layout: false }
			end
		end
	end

	# PRIVATE METHODS
	# ============================================================
	private

	# Find Model Type and ID
	def tracked_params
		@tracked_type = request.fullpath.split("/")[1].singularize
		@tracked_id   = params[@tracked_type.downcase.underscore + '_id']
	end

end
