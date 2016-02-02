class Admin::ControlsController < ApplicationController

	# FILTERS
	# ============================================================
	before_action :can_view?

	# PUBLIC METHODS
	# ============================================================
	def show
		@user   = current_user.decorate
		@facets = Facet.alphabetic.includes(:identities).decorate
	end

	# PRIVATE METHODS
	# ============================================================
	private

	def can_view?
		unless current_user.admin?
			redirect_to root_url
		end
	end

end