class Users::DashboardsController < ApplicationController
	
	# FILTERS
	# ============================================================
	before_action :can_view?, only: [:show]
	
	# PUBLIC METHODS
	# ============================================================
	def show
		@user      = current_user.decorate
		@pen_names = PenNamingsDecorator.decorate(current_user.pen_namings)
		@skins     = @user.skins
	end

	# PRIVATE METHODS
	# ============================================================
	private

	def can_view?
		unless user_signed_in?
			redirect_to new_user_session_path
		end
	end

end
