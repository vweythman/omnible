class Works::FictionController < WorksController

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private

	# Works :: find all with filtering
	def works
		@works = Collectables::FictionDecorator.decorate(Work.toggle_links(show_links).fiction.with_filters(index_params, current_user))
	end

end
