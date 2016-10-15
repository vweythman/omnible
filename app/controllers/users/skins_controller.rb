class Users::SkinsController < ApplicationController

	# FILTERS
	# ============================================================
	before_action :is_signed_in?, only: [:index]

	# PUBLIC METHODS
	# ============================================================
	# GET
	# ------------------------------------------------------------
	def index
		@uploads = @skins = current_user.skins.decorate
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
