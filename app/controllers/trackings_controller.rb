class TrackingsController < ApplicationController

	before_action :signed_restriction

	def create
		tracked_type   = request.fullpath.split("/")[1].singularize
		tracked_id     = params[tracked_type.downcase.underscore + '_id']
		@to_be_tracked = tracked_type.classify.constantize.find(tracked_id)

		unless @to_be_tracked.uploader? current_user
			current_user.track @to_be_tracked

			respond_to do |format|
				format.js { render layout: false }
			end
		end
	end

	def destroy
		tracked_type = request.fullpath.split("/")[1].singularize
		tracked_id   = params[tracked_type.downcase.underscore + '_id']
		@tracked     = tracked_type.classify.constantize.find(tracked_id)

		if current_user.tracking? @tracked
			current_user.untrack(@tracked)

			respond_to do |format|
				format.js { render layout: false }
			end
		end
	end

end
