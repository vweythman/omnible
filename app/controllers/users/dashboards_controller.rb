class Users::DashboardsController < ApplicationController
	
	# FILTERS
	# ------------------------------------------------------------
	before_action :ensure_signed_in, only: [:show]
	
	# PUBLIC METHODS
	# ------------------------------------------------------------
	def show
		@user      = current_user.decorate
		@pen_names = PenNamingsDecorator.decorate(current_user.pen_namings)
		@skins     = @user.skins
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
