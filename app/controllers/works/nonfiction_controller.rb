class Works::NonfictionController < WorksController

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private

	# Works :: find all with filtering
	def works
		@works = NonfictionDecorator.decorate(Work.nonfiction.with_filters(index_params, current_user))
	end

end
