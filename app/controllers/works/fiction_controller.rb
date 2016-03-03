class Works::FictionController < WorksController

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private

	# Works :: find all with filtering
	def works
		@works = FictionDecorator.decorate(Work.fiction.with_filters(index_params, current_user))
	end

end
