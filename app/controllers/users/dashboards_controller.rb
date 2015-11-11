class Users::DashboardsController < ApplicationController
	
	# PUBLIC METHODS
	# ------------------------------------------------------------
	# GET
	# ............................................................
	def show
		unless user_signed_in?
			redirect_to new_user_session_path
		end
		@user      = current_user.decorate
		@pen_names = PenNamingsDecorator.decorate(current_user.pen_namings)
	end

end
