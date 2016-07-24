class MediumsController < ApplicationController
	# PUBLIC METHODS
	# ============================================================
	# GET
	# ------------------------------------------------------------
	def index
		@metadata = RecordMetadatum.works_by_mediums
	end

	def show
		@medium = params[:medium]
		@works  = RecordMetadatum.works_by_medium(@medium)
	end
end
