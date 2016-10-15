class Users::UploadsController < ApplicationController

	# FILTERS
	# ============================================================
	before_action :is_signed_in?

	# PUBLIC METHODS
	# ============================================================
	# GET
	# ------------------------------------------------------------
	def index
		@resource_type = params[:resource_type]

		# ALL UPLOADS
		if @resource_type.nil?
			@uploads = current_user.all_uploads.sort_by! { |x| x.heading.downcase }

		# ROLEPLAY CHARACTERS
		elsif @resource_type == 'roleplay_character'
			@uploads = current_user.roleplay_characters.alphabetical

		elsif @resource_type == 'anthology'
			@uploads = current_user.anthologies.alphabetic

		# ALL WORKS
		elsif @resource_type == 'work'
			@uploads = current_user.works.onsite

		# WORKS BY TYPE
		else
			@uploads = current_user.works.by_type(@resource_type.camelize)
		end

		@uploads = Collectables::UploadsDecorator.decorate @uploads
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
