class Admin::ControlsController < ApplicationController

	# FILTERS
	# ============================================================
	before_action :admin_restriction

	# PUBLIC METHODS
	# ============================================================
	def show
		@user   = current_user.decorate
		@facets = Facet.alphabetic.includes(:identities).decorate
	end

end