class Users::UploadsController < ApplicationController

	# FILTERS
	# ============================================================
	before_action :is_signed_in?

	# PUBLIC METHODS
	# ============================================================
	# GET
	# ------------------------------------------------------------
	def index
		@uploads = current_user.all_uploads.sort_by! { |x| x.heading.downcase }
	end

	# PRIVATE METHODS
	# ============================================================
	private

	def is_signed_in?
		unless user_signed_in?
			redirect_to new_user_session_path
		end
	end

end
