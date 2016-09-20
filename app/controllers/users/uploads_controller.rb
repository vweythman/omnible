class Users::UploadsController < ApplicationController

	# FILTERS
	# ============================================================
	before_action :is_signed_in?

	# PUBLIC METHODS
	# ============================================================
	# GET
	# ------------------------------------------------------------
	def index
		resource_type = params[:resource_type]

		if resource_type.nil?
			@uploads = current_user.all_uploads.sort_by! { |x| x.heading.downcase }

		elsif resource_type == 'roleplay_character'
			@uploads = current_user.roleplay_characters.alphabetical

		elsif resource_type == 'work'
			@uploads = current_user.works.onsite

		else
			@uploads = current_user.works.by_type(resource_type.camelize)
		end
	end

	def show
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
