class Works::FictionController < WorksController

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private

	# find all with options from a works_controller filter
	def find_works
		@works = Fiction.with_filters(index_params, current_user)
		@works = FictionDecorator.decorate(@works)
	end

end
