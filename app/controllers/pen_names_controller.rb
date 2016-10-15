class PenNamesController < ApplicationController

	# PUBLIC METHODS
	# ============================================================
	# GET
	# ------------------------------------------------------------
	def show
		@pen = PenNamingDecorator.decorate Character.find(params[:id])
	end

end
