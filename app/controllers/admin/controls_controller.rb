class Admin::ControlsController < ApplicationController

	# FILTERS
	# ------------------------------------------------------------
	before_action :ensure_viewable, only: [:show]

	# PUBLIC METHODS
	# ------------------------------------------------------------
	def show
		@user   = current_user.decorate
		@facets = Facet.alphabetic.includes(:identities).decorate
	end

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private
	def ensure_viewable
		unless current_user.admin?
			redirect_to root_url
		end
	end

end
