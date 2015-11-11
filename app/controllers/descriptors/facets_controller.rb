class Descriptors::FacetsController < ApplicationController

	# PUBLIC METHODS
	# ------------------------------------------------------------
	# GET
	# ............................................................
	def index
		@facets = Facet.order(:name).all
	end

	def show
		@facet = Facet.find(param[:id])
	end

end
