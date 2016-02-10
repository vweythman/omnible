class JournalsController < ApplicationController

	# PRIVATE METHODS
	# ============================================================
	def work
		super
		@journal = @work
	end

end
