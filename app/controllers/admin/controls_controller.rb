class Admin::ControlsController < ApplicationController

	# FILTERS
	# ============================================================
	before_action :admin_restriction

	# PUBLIC METHODS
	# ============================================================
	def show
		@user   = current_user.decorate
		@facets = Collectables::FacetsDecorator.decorate Facet.alphabetic.includes(:identities)
	end

end