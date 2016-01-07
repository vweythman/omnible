class Users::SkinsController < ApplicationController

	# FILTERS
	# ------------------------------------------------------------
	before_action :ensure_signed_in, only: [:index]

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# GET
	# ............................................................
	def index
		@skins = current_user.skins
	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private
	def ensure_signed_in
		unless user_signed_in?
			redirect_to new_user_session_path
		end
	end

end
