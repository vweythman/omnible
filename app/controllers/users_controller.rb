class UsersController < ApplicationController

	# PUBLIC METHODS
	# ============================================================
	# GET
	# ------------------------------------------------------------
	def show
		@user = User.find(params[:id]).decorate
	end

end
