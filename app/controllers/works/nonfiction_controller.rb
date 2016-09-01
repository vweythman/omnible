class Works::NonfictionController < WorksController

	# PRIVATE METHODS
	# ------------------------------------------------------------
	private

	# Works :: find all with filtering
	def works
		@works = Collectables::Works::NonfictionDecorator.decorate(Work.toggle_links(show_links).nonfiction.with_filters(index_params, current_user))
	end

end
